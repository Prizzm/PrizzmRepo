class ShareObserver < ActiveRecord::Observer
  
  observe Shares::Share
  
  def before_validation (share)
    share.shortcode ||= Shortcode.new
    share.user ||= share.topic.user
    share.visitor_code ||= share.topic.pass_visitor_code
  end
  
  def after_create (share)
    case share
      when Shares::Email
        Notifications.delay(:queue => 'Notifications').share(share)
    end
    
    if share.user
      case share
        when Shares::Tweet
          share.user.points.add :tweeting, :allocatable => share.topic
        when Shares::Recommend
          share.user.points.add :recommending, :allocatable => share.topic
      end
    end
  end
  
end

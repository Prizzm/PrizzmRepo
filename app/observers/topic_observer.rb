class TopicObserver < ActiveRecord::Observer
  
  def before_validation (topic)
    topic.shortcode ||= Shortcode.new
  end
  
  def before_create (topic)

    # Topic Forms..
    case topic.form?
      when :business_recommendation
        topic.share_title = "I recommend %s!" % topic.user.name
      when :recommendation
        product = topic.subject
        topic.subject = "Would you recommend your %s?" % product
        topic.body = "We really value your feedback on your %s.   Would you recommend it to your friends?  And if you don't recommend it please tell us why.  Your feedback goes straight to us here at %s , so please let us know exactly what you think." % [ product, topic.user.name ]
        topic.share_title = "I recommend %s by %s!" % [ product, topic.user.name ]
      when :recommend
        topic.body = "I recommend you check out %s!" % topic.subject
    end
    
  end
  
  def after_create (topic)
    if topic.user
      topic.user.points.add :starting_a_topic, :allocatable => topic
    end
  end
  
end
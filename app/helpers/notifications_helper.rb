module NotificationsHelper
  
  def url (path)
    URI::join(root_url, path.to_s)
  end
  
  def table (*classes, &block)
    classes = classes.join(" ")
    content_tag :table, :class => classes do
      content_tag :tr do
        content_tag(:td, :class => classes, &block)
      end
    end
  end
  
  def image_link (image_url, url)
    link_to image_tag(image_url), url
  end
  
  def lines (&block)
    simple_format(capture(&block)).html_safe
  end
  
  def sent_to_by
    ("This email was sent to %s by %s." % 
      [ mail_to(@to_email), mail_to(@from_email) ]).html_safe
  end
  
end
module InterestsHelper
  def embed(url)
    "<iframe src='#{url}?controls=0' height='185px' width='100%' 
                    frameborder='0' 
                      scrolling='no' webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>".html_safe
  end

  def interest_metadata(provider, interest_type)
    [interest_type.try(:humanize), provider].reject(&:blank?).join("/")
  end

  def linked_interest_tag_list(interest)
    list = interest.tag_list.collect do |tag|
      link_to tag, interests_path(tagged: tag), class: "label"
    end.join(", ")
    list << "<br>" if list.present?
    list.html_safe
  end
end

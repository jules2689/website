module TagHelper
  def linked_tag_list(object)
    list = object.tag_list.collect do |tag|
      "<span class=\"badge\">" + link_to(tag, action: 'index', tagged: tag) + "</span>"
    end.join("")
    list << "<br>" if list.present?
    list.html_safe
  end
end

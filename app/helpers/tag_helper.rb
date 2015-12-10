module TagHelper
  include ActsAsTaggableOn::TagsHelper

  def linked_tag_list(object, spanned: true)
    list = object.tag_list.collect do |tag|
      link = link_to(tag, action: 'index', tagged: tag)
      if spanned
        "<span class=\"badge\">" + link + "</span>"
      else
        link
      end
    end

    if list.present?
      list = spanned ? list.join("") : list.join(", ")
      list << "<br>"
    end

    list.try(:html_safe)
  end
end

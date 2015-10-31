module PostsHelper
  include ActsAsTaggableOn::TagsHelper

  def linked_tag_list(post)
    list = post.tag_list.collect do |tag|
      link_to tag, posts_path(tagged: tag)
    end.join(", ")
    list << "<br>" if list.present?
    list.html_safe
  end

  def header_height(header_image_url)
    image = FastImage.size(header_image_url)
    image.present? ? image.last : 150
  end

  def top_for_header(post)
  	top = header_height(post.header_image_url) - 120
  	"style=\"margin-top: #{top}px !important\"".html_safe
  end

  def style_for_header_image_on_post(post)
  	if post.header_image_url.present?
	  	style = "style=\"background: url(#{ post.header_image_url });"
	  	style << "-webkit-box-shadow: inset 0px -85px 78px 16px ##{ post.dominant_header_colour };"
	  	style << "-moz-box-shadow: inset 0px -85px 78px 16px ##{ post.dominant_header_colour };"
	  	style << "box-shadow: inset 0px -85px 78px 16px ##{ post.dominant_header_colour };"
	  	style << "height: #{ header_height(post.header_image_url) }px !important;\""
	  	style.html_safe
	  end
  end
end

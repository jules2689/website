module PostsHelper
  include ActsAsTaggableOn::TagsHelper

  def linked_tag_list(post)
    post.tag_list.collect do |tag|
      link_to tag, posts_path(tagged: tag)
    end.join(", ").html_safe
  end

  def header_height(header_image)
    header_image.height > 500 ? 500 : header_image.height
  end

  def top_for_header(post)
  	height = post && post.header_image_stored? ? header_height(post.header_image) : 150
  	top = height - 120
  	"style=\"margin-top: #{top}px !important\"".html_safe
  end

  def style_for_header_image_on_post(post)
  	if post.header_image_stored?
	  	style = "style=\"background: url(#{ post.header_image.url });"
	  	style << "-webkit-box-shadow: inset 0px -85px 78px 16px ##{ post.dominant_header_colour };"
	  	style << "-moz-box-shadow: inset 0px -85px 78px 16px ##{ post.dominant_header_colour };"
	  	style << "box-shadow: inset 0px -85px 78px 16px ##{ post.dominant_header_colour };"
	  	style << "height: #{ header_height(post.header_image) }px !important;\""
	  	style.html_safe
	end
  end
end

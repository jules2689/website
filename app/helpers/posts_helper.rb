module PostsHelper
  include ActsAsTaggableOn::TagsHelper

  def linked_tag_list(post)
    post.tag_list.collect do |tag|
      link_to tag, posts_path(tagged: tag)
    end.join.html_safe
  end
end

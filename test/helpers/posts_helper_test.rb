require 'test_helper'

class PostsHelperTest < ActionView::TestCase


  test "linked_tag_list" do
    post = posts(:one)
    post.tag_list = "test, test1"
    expected = "<a href=\"/posts?tagged=test\">test</a>, <a href=\"/posts?tagged=test1\">test1</a>"
    assert_equal expected, linked_tag_list(post)
  end
end

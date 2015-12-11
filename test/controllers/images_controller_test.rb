require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  test "should create image" do
    post :create_github_image, image: fixture_file_upload('images/test.jpg', 'image/jpg'), format: :js
    expected_response = { title: "Title", url: "http://gitcdn.jnadeau.ca/images/website/path.jpg" }
    assert_equal expected_response, assigns(:image)
  end

  test "should create gallery" do
    first = { title: "first", url: "http://gitcdn.jnadeau.ca/images/website/first.jpg" }
    second = { title: "second", url: "http://gitcdn.jnadeau.ca/images/website/second.jpg" }
    ImageMaker.any_instance.expects(:create_image).twice.returns(first).then.returns(second)

    post :create_gallery, images: [["image1", { image: fixture_file_upload('images/test.jpg', 'image/jpg'), title: "Title1" }],
                                   ["image2", { image: fixture_file_upload('images/test.jpg', 'image/jpg'), title: "Title2" }]], format: :js
    assert_equal [first, second], assigns(:images)
  end
end

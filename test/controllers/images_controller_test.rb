require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  setup do
    @image = images(:one)
  end

  # test "should create image" do
  #   assert_difference('Image.count') do
  #     post :create, image: {  }
  #   end

  #   assert_redirected_to image_path(assigns(:image))
  # end
end

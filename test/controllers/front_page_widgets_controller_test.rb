require 'test_helper'

class FrontPageWidgetsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @front_page_widget = front_page_widgets(:one)
    @front_page_widget_2 = front_page_widgets(:two)
    sign_in(users(:one))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:front_page_widgets)
  end


  test "should get positions" do
    get :positions
    assert_response :success
    assert_not_nil assigns(:front_page_widgets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should save positions" do
    post :save_positions, positions: ["#{@front_page_widget.id},55","#{@front_page_widget_2.id},56"]
    assert_redirected_to root_url
    assert_equal 55, @front_page_widget.reload.position
    assert_equal 56, @front_page_widget_2.reload.position
  end

  test "should create front_page_widget" do
    assert_difference('FrontPageWidget.count') do
      post :create, front_page_widget: { url: "http://example.com", image: fixture_file_upload('images/test.jpg', 'image/jpg'), subtext: @front_page_widget.subtext, title: @front_page_widget.title }
    end

    assert_redirected_to root_url
  end

  test "should get edit" do
    get :edit, id: @front_page_widget
    assert_response :success
  end

  test "should update front_page_widget" do
    patch :update, id: @front_page_widget, front_page_widget: { image: fixture_file_upload('images/test.jpg', 'image/jpg'), subtext: @front_page_widget.subtext, title: @front_page_widget.title }
    assert_redirected_to root_url
  end

  test "should destroy front_page_widget" do
    assert_difference('FrontPageWidget.count', -1) do
      delete :destroy, id: @front_page_widget
    end

    assert_redirected_to root_url
  end
end

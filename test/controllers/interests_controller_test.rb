require 'test_helper'

class InterestsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @interest = interests(:one)
    sign_in(users(:one))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create interest" do
    assert_difference('Interest.count') do
      post :create, interest: { url: "http://google.com" }
    end
    assert_redirected_to interests_path
  end

  test "should destroy interest" do
    assert_difference('Interest.count', -1) do
      delete :destroy, id: @interest
    end

    assert_redirected_to interests_path
  end

  test "should get tags" do
    get :tags, query: "third"
    assert_response :success
    assert_equal ["A third Tag"], JSON.parse(response.body)["suggestions"]
  end
end

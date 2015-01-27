require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
    basic = ActionController::HttpAuthentication::Basic
    @credentials = basic.encode_credentials(Julianssite::Username, Julianssite::Password)
    request.headers['Authorization'] = @credentials
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count') do
      post :create, post: { body: @post.body, handle: @post.handle, title: @post.title }
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should show post" do
    get :show, handle: @post
    assert_response :success
  end

  test "should get edit" do
    get :edit, handle: @post
    assert_response :success
  end

  test "should update post" do
    patch :update, handle: @post, post: { body: @post.body, handle: @post.handle, title: @post.title }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, handle: @post
    end

    assert_redirected_to posts_path
  end

  # Unauthenticated

  test "should get index while unauthorized" do
    request.headers['Authorization'] = nil
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should not get new while unauthorized" do
    request.headers['Authorization'] = nil
    get :new
    assert_response :unauthorized
  end

  test "should not create post while unauthorized" do
    request.headers['Authorization'] = nil
    assert_no_difference('Post.count') do
      post :create, post: { body: @post.body, handle: @post.handle, title: @post.title }
    end

    assert_response :unauthorized
  end

  test "should show post while unauthorized" do
    request.headers['Authorization'] = nil
    get :show, handle: @post
    assert_response :success
  end

  test "should not get edit while unauthorized" do
    request.headers['Authorization'] = nil
    get :edit, handle: @post
    assert_response :unauthorized
  end

  test "should not update post while unauthorized" do
    request.headers['Authorization'] = nil
    patch :update, handle: @post, post: { body: @post.body, handle: @post.handle, title: @post.title }
    assert_response :unauthorized
  end

  test "should not destroy post while unauthorized" do
    request.headers['Authorization'] = nil
    assert_no_difference('Post.count', -1) do
      delete :destroy, handle: @post
    end

    assert_response :unauthorized
  end
end

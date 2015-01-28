require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @post = posts(:one)
    @user = users(:one)
    sign_in(@user)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should not get all posts" do
    get :all_posts
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
    sign_out(@user)
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should not get all_posts while unauthorized" do
    sign_out(@user)
    get :all_posts
    assert_redirected_to new_user_session_path
  end

  test "should not get new while unauthorized" do
    sign_out(@user)
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should not create post while unauthorized" do
    sign_out(@user)
    assert_no_difference('Post.count') do
      post :create, post: { body: @post.body, handle: @post.handle, title: @post.title }
    end

    assert_redirected_to new_user_session_path
  end

  test "should show post while unauthorized" do
    sign_out(@user)
    get :show, handle: @post
    assert_response :success
  end

  test "should not get edit while unauthorized" do
    sign_out(@user)
    get :edit, handle: @post
    assert_redirected_to new_user_session_path
  end

  test "should not update post while unauthorized" do
    sign_out(@user)
    patch :update, handle: @post, post: { body: @post.body, handle: @post.handle, title: @post.title }
    assert_redirected_to new_user_session_path
  end

  test "should not destroy post while unauthorized" do
   sign_out(@user)
    assert_no_difference('Post.count', -1) do
      delete :destroy, handle: @post
    end

    assert_redirected_to new_user_session_path
  end
end

require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @post = posts(:one)
    @post2 = Post.unscoped.find(2)
    @user = users(:one)
    sign_in(@user)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
    assert assigns(:posts).include?(@post2)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count') do
      post :create, post: { body: @post.body, handle: @post.handle, title: @post.title, image: fixture_file_upload('images/test.jpg', 'image/jpg'), tag_list: "a,b,c" }
    end

    assert_not_nil assigns(:post).header_image_url
    assert_redirected_to post_path(assigns(:post))
  end

  test "should show post" do
    get :show, handle: @post
    assert_response :success
  end

  test "should not show unpublished post" do
    sign_out :user
    @post.published_date = 10.days.from_now
    @post.save

    get :show, handle: @post
    assert_redirected_to posts_path
  end

  test "should show unpublished post with key" do
    sign_out :user
    @post.published_date = 10.days.from_now
    @post.save

    get :show, handle: @post, published_key: @post.published_key
    assert_response :success
  end

  test "should not show unpublished post with wrong key" do
    sign_out :user
    @post.published_date = 10.days.from_now
    @post.save

    get :show, handle: @post, published_key: "wrong"
    assert_redirected_to posts_path
  end

  test "should change key" do
    post :regenerate_published_key, handle: @post
    assert_not_equal @post.published_key, @post.reload.published_key
    assert_redirected_to @post
  end

  test "should get edit" do
    get :edit, handle: @post
    assert_response :success
  end

  test "should update post" do
    patch :update, handle: @post, post: { body: @post.body, handle: @post.handle, title: @post.title }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should remove header image" do
    patch :update, handle: @post, post: { body: @post.body, handle: @post.handle, title: @post.title }, remove_image: true
    assert_equal "", assigns(:post).header_image_url
    assert_redirected_to post_path(assigns(:post))
  end

  test "should update header image" do
    new_path = "http://gitcdn.jnadeau.ca/images/website/new_path.jpg"
    ImageMaker.any_instance.stubs(:create_image).returns(title: "Title", url: new_path)

    patch :update, handle: @post, post: { body: @post.body, handle: @post.handle, title: @post.title, image: fixture_file_upload('images/test.jpg', 'image/jpg') }
    assert_equal new_path, assigns(:post).header_image_url
    assert_redirected_to post_path(assigns(:post))
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, handle: @post
    end

    assert_redirected_to posts_path
  end

  test "should get tags" do
    get :tags, query: "another"
    assert_response :success
    assert_equal ["Another Tag"], JSON.parse(response.body)["suggestions"]
  end

  # Unauthenticated

  test "should get index while unauthorized" do
    sign_out(@user)
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
    refute assigns(:posts).include?(@post2)
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

  test "should not change key when not authenticated" do
    sign_out :user

    post :regenerate_published_key, handle: @post
    assert_equal @post.published_key, @post.reload.published_key
    assert_redirected_to new_user_session_path
  end
end

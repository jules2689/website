class PostsController < ApplicationController
  include TagActions
  before_action :authenticate_user!, except: [:index, :show, :tag_cloud]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :regenerate_published_key]

  def index
    if params[:tagged]
      @posts = Post.scoped_posts(signed_in?).tagged_with(params[:tagged]).paginate(page: params[:page], per_page: 7)
    else
      @posts = Post.scoped_posts(signed_in?).paginate(page: params[:page], per_page: 8)
    end
    @tags = Post.tag_counts_on(:tags).to_a.sort_by(&:name)
  end

  def show
    redirect_to posts_path unless signed_in? || @post.published? || @post.can_allow_unpublished_view?(params[:published_key])
    @tags = Post.tag_counts_on(:tags).to_a.sort_by(&:name)
  end

  def regenerate_published_key
    @post.published_key = nil
    @post.save
    redirect_to @post, notice: "Regenerated key"
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    update_params = post_params.merge("remove_image" => params[:remove_image])
    respond_to do |format|
      if @post.update(update_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_post
    @post = Post.unscoped.find_by(handle: params[:handle])
  end

  def post_params
    params.require(:post).permit(:title, :body, :tag_list, :published_date, :image, :remove_image)
  end
end

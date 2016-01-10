class PostsController < ApplicationController
  include TagActions
  before_action :authenticate_user!, except: [:index, :show, :tag_cloud]
  before_action :set_post_and_category, only: [:show, :edit, :update, :destroy, :regenerate_published_key]
  before_action :set_or_create_post_category, only: [:create, :update]

  def index
    @posts = Post.scoped_posts(signed_in?).includes(:post_category)
    @posts = @posts.tagged_with(params[:tagged]) if params[:tagged].present?
    @posts = @posts.where(post_category_id: PostCategory.find_by(title: params[:category])) if params[:category].present?
    @posts = @posts.paginate(page: params[:page], per_page: 12)

    @tags = Post.tag_counts_on(:tags).to_a.sort_by(&:name)
    @post_categories = PostCategory.where('posts_count > 0')
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

  def set_post_and_category
    @post = Post.unscoped.find_by(handle: params[:handle])
    if @post.nil?
      render file: "#{Rails.root}/public/404.html", status: 404
    else
      @post_category = @post.post_category
    end
  end

  def set_or_create_post_category
    @post_category = PostCategory.where(id: post_params[:post_category_id]).first
    @post_category = PostCategory.create(title: post_params[:post_category_id]) if @post_category.nil?

    params[:post][:post_category_id] = @post_category.id
  end

  def post_params
    params.require(:post).permit(:title, :body, :tag_list, :published_date, :post_category_id, :image, :remove_image)
  end
end

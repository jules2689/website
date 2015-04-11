class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :tag_cloud]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    if params[:tagged]
      @posts = Post.scoped_posts(signed_in?).tagged_with(params[:tagged]).paginate(page: params[:page], per_page: 7)
    else
      @posts = Post.scoped_posts(signed_in?).paginate(page: params[:page], per_page: 7)
    end
    @tags = Post.tag_counts_on(:tags).to_a.sort_by { |t| t.name }
  end

  def show
    redirect_to posts_path unless signed_in? || @post.published?
    @tags = Post.tag_counts_on(:tags).to_a.sort_by { |t| t.name }
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
        process_images if params[:post][:image_ids]
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
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

  def process_images
    params[:post][:image_ids].split(",").each do |id|
      image = Image.find(id)
      image.post = @post
      image.save
    end
  end

  def set_post
    @post = Post.unscoped.find_by(handle: params[:handle])
  end

  def post_params
    params.require(:post).permit(:title, :body, :tag_list, :published_date, :header_image, :remove_header_image)
  end
end

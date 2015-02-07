class ImagesController < ApplicationController
  before_action :set_post

  def create
    @image = @post.images.create(image_params)
    respond_to do |format|
      format.js
    end  
  end

  def destroy
    @image.destroy
    respond_with(@image)
  end

  private
    def set_post
      @post = Post.find_by(handle: params[:post_handle])
    end

    def image_params
      params.require(:image).permit(:image, :title, :width)
    end
end

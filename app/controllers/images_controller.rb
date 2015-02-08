class ImagesController < ApplicationController
  before_action :set_post

  def create
    @image = Image.create(image_params)
    respond_to do |format|
      format.js
    end  
  end

  private
    def set_post
      @post = Post.find_by(handle: params[:post_handle])
    end

    def image_params
      params.require(:image).permit(:image, :title, :width, :post_id)
    end
end

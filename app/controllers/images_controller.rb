class ImagesController < ApplicationController

  def create
    @image = Image.create(image_params)
    respond_to do |format|
      format.js
    end  
  end

  private

  def image_params
    params.require(:image).permit(:image, :title, :width, :owner_id)
  end
end

class ImagesController < ApplicationController
  def create_github_image
    title = image_title(params[:image])
    name = image_file_name(params[:image])

    @image = image_maker.create_image(title, file_path(name), params[:image])
  end

  def create_gallery
    @images = []

    params[:images].each do |image_hash|
      image = image_hash.last["image"]
      title = image_hash.last["title"]

      image_title = image_title(image, title)
      name = image_file_name(image, image_title)
      path = file_path(name)

      # Reset Params
      @title = nil
      @image_file_name = nil

      @images << image_maker.create_image(title, path, image)
    end

    @images
  end

  private

  def image_maker
    @image_maker ||= ImageMaker.new
  end

  def file_path(name)
    @path ||= params[:file].try(:parameterize).try(:gsub, /-/, "_")
    [@path, name].reject(&:blank?).join("/")
  end

  def image_title(image, title = params[:title])
    image_name = image.original_filename.split(".")
    @title ||= title.present? ? title.parameterize.tr('-', "_") : image_name.first.downcase.tr('-', "_")
  end

  def image_file_name(image, title = params[:title])
    image_name = image.original_filename.split(".")
    ext = image_name.last.downcase
    @image_file_name ||= "#{image_title(image, title)}_#{Time.now.to_i}.#{ext}"
  end

  def image_params
    params.require(:image).permit(:image, :title, :width, :owner_id)
  end
end

class ImagesController < ApplicationController

  def create_github_image
    client = Octokit::Client.new(access_token: ENV["WEBSITE_GITHUB_KEY"])

    title = image_title(params[:image])
    name = image_file_name(params[:image])
    path = file_path(name)

    @image = create_image(title, file_path, params[:image])
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

      @images << create_image(title, path, image)
    end

    @images
  end

  private

  def create_image(title, path, image)
    Rails.logger.info("Creating image '#{title}'...")
    client.create_contents("jules2689/gitcdn",
                           "images/website/#{path}",
                           "Adding Image #{path}",
                            branch: "gh-pages",
                            file: image.path)
    { title: title, url: "http://gitcdn.jnadeau.ca/images/website/#{path}" }
  end

  def client
    @client ||= Octokit::Client.new(access_token: ENV["WEBSITE_GITHUB_KEY"])
  end

  def file_path(name)
    @path ||= params[:file].try(:parameterize).try(:gsub, /-/, "_")
    [@path, name].reject(&:blank?).join("/")
  end

  def image_title(image, title=params[:title])
    image_name = image.original_filename.split(".")
    @title ||= title.present? ? title.parameterize.gsub(/-/,"_") : image_name.first.downcase.gsub(/-/,"_")
  end

  def image_file_name(image, title=params[:title])
    image_name = image.original_filename.split(".")
    ext = image_name.last.downcase
    @image_file_name ||= "#{image_title(image, title)}_#{Time.now.to_i}.#{ext}"
  end

  def image_params
    params.require(:image).permit(:image, :title, :width, :owner_id)
  end
end

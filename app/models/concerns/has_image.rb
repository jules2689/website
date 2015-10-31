module HasImage
  def update(params)
    # Remove image url if necessary
    if params[:remove_image]
      params[:header_url] = ""
    end

    # Add image url if necessary
    if params[:image].present?
      image_name = params[:image].original_filename
      title = image_name.split(".").first.downcase.gsub(/-/,"_")
      image_maker = ImageMaker.new.create_image(title, "headers/#{image_name.gsub(/\s+/,"_")}", params[:image])
      params[:image_url] = image_maker[:url]
    end

    params.delete(:remove_image)
    params.delete(:image)
    super(params)
  end
end

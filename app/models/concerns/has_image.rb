module HasImage
  IMAGE_URL_ATTR = "image_url"

  def update(attributes)
    remove_image(attributes)
    assign_image_from_params(attributes)
    super(attributes)
  end

  def create(attributes)
    assign_image_from_params(attributes)
    super(attributes)
  end

  def initialize(attributes = nil, options = {})
    assign_image_from_params(attributes)
    super(attributes, options)
  end

  def assign_image_from_params(attributes)
    if !attributes.nil? && attributes[:image].present?
      image_name = attributes[:image].original_filename
      title = image_name.split(".").first.downcase.tr('-', "_")
      image_maker = ImageMaker.new.create_image(title, "headers/#{image_name.gsub(/\s+/, '_')}", attributes[:image])
      attributes[self.class::IMAGE_URL_ATTR] = image_maker[:url]
    end
    attributes.delete(:image) if attributes
  end

  def remove_image(attributes)
    attributes[self.class::IMAGE_URL_ATTR] = "" if attributes[:remove_image]
    attributes.delete(:remove_image) if attributes
  end
end

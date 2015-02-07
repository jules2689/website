include Colorscore

class Image < ActiveRecord::Base
  dragonfly_accessor :image do
    after_assign :set_dominant_color
  end

  belongs_to :post
  delegate :path, :url, to: :image
  validates_property :format, of: :image, in: [:jpeg, :jpg, :png, :bmp], case_sensitive: false, message: "should be either .jpeg, .jpg, .png, .bmp", if: :image_changed?

  private

  after_create :resize
  def resize
    if self.width.present?
      self.image = self.image.thumb("#{self.width}x")
      self.save
    end
  end

  def set_dominant_color
    histogram = Histogram.new(image.path)
    self.dominant_colour = histogram.scores.first.last.hex
  end
end

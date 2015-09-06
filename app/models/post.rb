include Colorscore

class Post < ActiveRecord::Base
  default_scope { where('published_date <= ?', DateTime.now).order(updated_at: :desc) }
  acts_as_ordered_taggable

  dragonfly_accessor :header_image do
    after_assign :set_dominant_colour
  end
  validates_property :format, of: :header_image, in: [:jpeg, :jpg, :png, :bmp], case_sensitive: false, message: "should be either .jpeg, .jpg, .png, .bmp", if: :header_image_changed?

  has_many :images, as: :owner
  accepts_nested_attributes_for :images

  validates_presence_of :title, :body
  before_validation :set_handle

  def est_created_at
    self.created_at + Time.zone_offset('EST')
  end

  def est_updated_at
    self.updated_at + Time.zone_offset('EST')
  end

  def trancated_body
    html_body.html_truncate(200)
  end

  def html_body
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(body).html_safe
  end

  def published?
    published_date.present? && published_date <= DateTime.now
  end

  def to_param
    handle
  end

  def self.scoped_posts(signed_in)
    if signed_in
      Post.unscoped.all.order(updated_at: :desc)
    else
      Post.all
    end
  end

  private

  def set_handle
    self.handle = self.title.downcase.parameterize
  end

  def set_dominant_colour
    histogram = Histogram.new(self.header_image.path)
    rgb_color =  histogram.scores.min_by { |h| h.last.brightness }.last
    self.dominant_header_colour = rgb_color.hex
  end
end

class Post < ActiveRecord::Base
  IMAGE_URL_ATTR = "header_image_url"
  include HasImage

  default_scope { where('published_date <= ?', DateTime.now.utc).order(created_at: :desc) }
  acts_as_ordered_taggable

  validates :title, :body, :tag_list, presence: :true
  validates :title, length: {minimum: 5, maximum: 50}
  before_validation :set_handle
  before_validation :set_published_key

  def est_created_at
    created_at + Time.zone_offset('EST')
  end

  def est_updated_at
    updated_at + Time.zone_offset('EST')
  end

  def trancated_body
    html_body.html_truncate(200)
  end

  def html_body
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, fenced_code_blocks: true)
    markdown.render(body).html_safe
  end

  def published?
    published_date.present? && published_date <= DateTime.now.utc
  end

  def to_param
    handle
  end

  def self.scoped_posts(signed_in)
    if signed_in
      Post.unscoped.all.order(created_at: :desc)
    else
      Post.all
    end
  end

  def can_allow_unpublished_view?(key)
    published_key == key
  end

  private

  def set_handle
    self.handle = title.downcase.parameterize
  end

  def set_published_key
    self.published_key = Digest::SHA1.hexdigest(title.downcase.parameterize + Time.zone.now.to_s) if published_key.blank?
  end

  def set_dominant_colour
    histogram = Histogram.new(header_image.path)
    rgb_color = histogram.scores.min_by { |h| h.last.brightness }.last
    self.dominant_header_colour = rgb_color.hex
  end
end

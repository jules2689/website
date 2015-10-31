include Colorscore
require 'screencap'

class Image < ActiveRecord::Base

  def url
    path
  end

  def height
    FastImage.size(url).last
  end

  # TODO: Refactor this out

  def self.capture_screenshot(url, owner)
    f = Screencap::Fetcher.new(url)
    path = Rails.root.join("public", "tmp_screencap", "#{url.parameterize}.png")
    screenshot = f.fetch(
      output: path,
      :height => 768,
      :top => 0, :left => 0
    )

    i = Image.new
    i.owner = owner
    i.image = File.new(path)
    i.save
  end

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

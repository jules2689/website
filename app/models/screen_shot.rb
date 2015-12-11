require 'screencap'

class ScreenShot
  def self.capture(url)
    path = Rails.root.join("public", "screencap", "#{url.parameterize}.png")
    f = Screencap::Fetcher.new(url)
    f.fetch(output: path, height: 768, top: 0, left: 0)
    ImageMaker.new.create_image("#{url.parameterize}.png", "screencap/#{url.parameterize}.png", path.to_s)
  end
end

require 'screencap'

class ScreenShot

  def self.capture(url)
    f = Screencap::Fetcher.new(url)
    screenshot = f.fetch(
      output: Rails.root.join("public", "screencap", "#{url.parameterize}.png"),
      :height => 768,
      :top => 0, :left => 0
    )

    ImageMaker.new.create_image("#{url.parameterize}.png", "screencap/#{url.parameterize}.png", File.read(path))
  end

end

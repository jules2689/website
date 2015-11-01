class ImageMaker

  def create_image(title, path, image)
    Rails.logger.info("Creating image '#{title}'...")
    Julianssite::GithubClient.create_contents("jules2689/gitcdn",
                           "images/website/#{path}",
                           "Adding Image #{path}",
                            branch: "gh-pages",
                            file: image.path)
    { title: title, url: "https://jules2689.github.io/gitcdn/images/website/#{path}" }
  end

end

class ImageMaker

  def create_image(title, path, image_path)
    image_path = image_path.path if image_path.respond_to?('path')

    Rails.logger.info("Creating image '#{title}'...")
    Julianssite::GithubClient.create_contents("jules2689/gitcdn",
                           "images/website/#{path}",
                           "Adding Image #{path}",
                            branch: "gh-pages",
                            file: image_path)
    { title: title, url: "https://jules2689.github.io/gitcdn/images/website/#{path}" }
  end

end

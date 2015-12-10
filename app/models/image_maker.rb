class ImageMaker

  def create_image(title, path, image_path)
    image_path = image_path.path if image_path.respond_to?('path')

    Rails.logger.info("Creating image '#{title}'...")
    images_path = "images/website/#{path}"
    Julianssite::GithubClient.create_contents("#{ENV["GIT_CDN_REPO"]}",
                           images_path,
                           "Adding Image #{path}",
                            branch: "gh-pages",
                            file: image_path)
    { title: title, url: "#{ENV["GIT_CDN_REPO_URL"]}#{images_path}" }
  end

end

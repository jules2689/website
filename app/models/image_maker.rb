class ImageMaker

  def create_image(title, path, image)
    Rails.logger.info("Creating image '#{title}'...")
    client.create_contents("jules2689/gitcdn",
                           "images/website/#{path}",
                           "Adding Image #{path}",
                            branch: "gh-pages",
                            file: image.path)
    { title: title, url: "http://gitcdn.jnadeau.ca/images/website/#{path}" }
  end

  def client
    @client ||= Octokit::Client.new(access_token: ENV["WEBSITE_GITHUB_KEY"])
  end

end

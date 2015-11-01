class ImageMaker

  def create_image(title, path, image)
    Rails.logger.info("Creating image '#{title}'...")
    client.create_contents("jules2689/gitcdn",
                           "images/website/#{path}",
                           "Adding Image #{path}",
                            branch: "gh-pages",
                            file: image.path)
    { title: title, url: "https://jules2689.github.io/gitcdn/images/website/#{path}" }
  end

  def client
    if ENV["WEBSITE_GITHUB_KEY"].present?
      puts "I have a github key"
    else
      puts "I don't have a github key"
    end
    
    @client ||= Octokit::Client.new(access_token: ENV["WEBSITE_GITHUB_KEY"])
  end

end

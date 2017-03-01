class ImageMaker
  def create_image(title, remote_path, image_path)
    image_path = image_path.path if image_path.respond_to?('path')

    Rails.logger.info("Creating image '#{title}'...")
    PersonalWebsite::GithubClient.create_contents(Rails.application.app_config.git_cdn_repo,
      remote_image_path(remote_path),
      "Adding Image #{remote_path}",
      branch: "gh-pages",
      file: image_path)
    { title: title, url: url(remote_path) }
  end

  def remote_image_path(remote_path)
    "images/website/#{remote_path}"
  end

  def url(remote_path)
    "#{Rails.application.app_config.git_cdn_repo_url}#{remote_image_path(remote_path)}"
  end

  def exists?(remote_path)
    url = url(remote_path)
    res = Net::HTTP.get_response(URI(url))
    res.code == '200'
  end
end

class ImageMaker
  def create_image(title, remote_path, file_path)
    image_path = file_path.path if file_path.respond_to?('path')

    Rails.logger.info("Creating image '#{title}'...")
    remote_image_path = "images/website/#{remote_path}"
    PersonalWebsite::GithubClient.create_contents("#{Rails.application.secrets.git_cdn_repo}",
      remote_image_path,
      "Adding Image #{remote_path}",
      branch: "gh-pages",
      file: image_path)
    { title: title, url: "#{Rails.application.secrets.git_cdn_repo_url}#{remote_image_path}" }
  end
end

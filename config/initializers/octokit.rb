if Rails.application.secrets.github_key.blank?
  Rails.logger.warn "ERROR: Github Key was not provided"
end
PersonalWebsite::GithubClient = Octokit::Client.new(access_token: Rails.application.secrets.github_key)

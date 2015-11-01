if Rails.application.secrets.github_key.blank?
  puts "ERROR: Github Key was not provided"
end
Julianssite::GithubClient = Octokit::Client.new(access_token: Rails.application.secrets.github_key)

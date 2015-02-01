require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "6881d6079095b4ad52e0d17c7cf5bd2afd3303c21033f51b1b4556df8739e474"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')

  fetch_url_whitelist [ /jnadeau\.ca/ ]
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end

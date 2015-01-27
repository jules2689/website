if Rails.env.production?
  Julianssite::Username = ENV["POST_USER"].freeze
  Julianssite::Password = ENV["POST_PASSWORD"].freeze
else
  Julianssite::Username = "julian".freeze
  Julianssite::Password = "password".freeze
end

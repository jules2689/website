source 'https://rubygems.org'

gem 'rails', '4.1.8'
gem 'puma'
gem 'pg'
gem 'newrelic_rpm'
gem 'rack-cache'

# Assets and JS
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'


# Gallery
gem 'galleria-rails', github: 'jules2689/galleria-rails'
gem 'fastimage'

# Github
gem 'octokit'

# Interests
gem 'screencap'
gem 'mechanize'

# Design Controls
gem 'bootstrap-sass', '~> 3.3.3'
gem 'jquery-datetimepicker-rails'

# Tagging
gem 'acts-as-taggable-on', '~> 3.4'

# Mark down and HTML
gem 'nokogiri'
gem 'pagedown-bootstrap-rails', git: "https://github.com/jules2689/pagedown-bootstrap-rails.git"
gem 'redcarpet'
gem 'builder'

# User Auth
gem 'devise'
gem 'devise-bootstrap-views'

# Pagination
gem 'will_paginate'
gem 'will_paginate-bootstrap'

# Ajax Forms
gem 'remotipart', '~> 1.2'

group :development, :test do
  gem 'pry-byebug'
end

group :development do
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-secrets-yml', '~> 1.0.0', require: false
  gem 'spring'
end

group :test do
  gem 'mocha'
end

group :production do
  gem 'rails_12factor'
end

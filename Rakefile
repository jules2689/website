# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :ssl do
  desc "Renew SSL certificates"
  task :renew do
    require 'le_ssl'
    require 'le_ssl/manager'

    email = 'julian@jnadeau.ca'
    domain = 'jnadeau.ca'
    
    # Initialize Rails for Rails.root and such
    ENV['RAILS_ENV'] = 'production'

    Rails.application.initialize!

    private_key = File.read("/home/deploy/apps/website/current/config/ssl/privkey.pem")
    manager = LeSSL::Manager.new(email: email, agree_terms: true, private_key: private_key)

    puts "Authorizing for domain #{domain}"
    manager.authorize_for_domain(domain)

    puts "Requesting certificate for #{domain}"
    manager.request_certificate(domain)
  end
end

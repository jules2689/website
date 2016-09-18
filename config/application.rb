require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'open3'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

GC::Profiler.enable

module PersonalWebsite
  class Application < Rails::Application
    attr_accessor :app_config
    Rails.application.app_config = OpenStruct.new(YAML.load_file(Rails.root.join('config', 'config.yml')))

    secrets_ejson_path = Rails.root.join('config', 'secrets', "#{Rails.env}.ejson")
    if File.exist?(secrets_ejson_path)
      encrypted_json = JSON.parse(secrets_ejson_path.read)
      public_key = encrypted_json['_public_key']
      raise "Private key is not listed in #{private_key_path}." unless File.exist?("/opt/ejson/keys/#{public_key}")

      output, status = Open3.capture2e("ejson", "decrypt", secrets_ejson_path.to_s)
      raise "ejson: #{output}" unless status.success?
      development_secrets = JSON.parse(output)[Rails.env].symbolize_keys
      Rails.application.secrets.merge!(development_secrets)
    end
  end
end

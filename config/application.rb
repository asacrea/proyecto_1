require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Proyecto11
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    
	Diplomat.configure do |config|
		host = ENV["CONSUL_HOST"]
		port = ENV["CONSUL_PORT"]

		if host.to_s.empty?
		  host = "localhost"
		end
		if port.to_s.empty?
		  port =  "8500"
		end

		puts "CONSUL_HOST=#{host}"
		puts "CONSUL_PORT=#{port}"

		config.url = "http://#{host}:#{port}"
	end
    
    hostname = Diplomat::Service.get('redis').Address
    port = Diplomat::Service.get('redis').ServicePort

	config.cache_store = :redis_store, "redis://#{hostname}:#{port}/0/cache", { expires_in: 90.minutes }
	
  end
end

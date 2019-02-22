require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Internos
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Load chamber settings because we use it in this file
    Chamber.load files: [Rails.root + 'config/settings.yml', Rails.root + 'config/settings/**/*.{yml,yml.erb}'],
                 decryption_key: Rails.root + 'config/chamber.pem',
                 namespaces: {
                   environment: -> { ::Rails.env },
                   hostname:    -> { Socket.gethostname } }
    # We need to initialize before load_environment_config because railties initialize it before config with default
    # parameters.
    initializer 'internos.chamber.load', before: :load_environment_config do
      Chamber.load files: [Rails.root + 'config/settings.yml', Rails.root + 'config/settings/**/*.{yml,yml.erb}'],
                   decryption_key: Rails.root + 'config/chamber.pem',
                   namespaces: {
                     environment: -> { ::Rails.env },
                     hostname:    -> { Socket.gethostname } }
    end

  end
end

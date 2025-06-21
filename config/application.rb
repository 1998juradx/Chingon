require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Chingon
  class Application < Rails::Application
    # Set defaults for Rails 7
    config.load_defaults 7.0

    # Timezone (used for timestamps, etc.)
    config.time_zone = "America/Bogota"
    config.i18n.default_locale = :es
    config.i18n.available_locales = [:es, :en]
    config.i18n.fallbacks = true
  end
end
# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
# require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require 'action_mailbox/engine'
# require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Zealot
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Set default timezone
    config.time_zone = ENV['TIME_ZONE'] || 'Beijing'
    config.active_record.default_timezone = :local

    # Set default locale
    locale = ENV['LOCALE'] || 'zh-CN'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = locale.to_sym
    config.i18n.available_locales = [locale, :en]

    # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
    # the I18n.default_locale when a translation cannot be found).
    config.i18n.fallbacks = [I18n.default_locale]

    # Action mailer settings.
    config.action_mailer.default_options = {
      from: ENV['ACTION_MAILER_DEFAULT_FROM'] || 'Zealot'
    }

    # Set Redis as the back-end for the cache.
    config.cache_store = :redis_cache_store, {
      url: (ENV['REDIS_URL'] || 'redis://localhost:6379/0'),
      namespace: ENV['REDIS_NAMESPACE'] || 'cache'
    }

    # Set Sidekiq as the back-end for Active Job.
    # Sidekiq not suggest to use perfix: https://github.com/mperham/sidekiq/issues/4034#issuecomment-442988685
    config.active_job.queue_adapter = :sidekiq

    # Action Cable setting to de-couple it from the main Rails process.
    # config.action_cable.url = ENV['ACTION_CABLE_FRONTEND_URL'] || 'ws://localhost:28080'

    # Action Cable setting to allow connections from these domains.
    # if origins = ENV['ACTION_CABLE_ALLOWED_REQUEST_ORIGINS']
    #   origins = origins.split(',')
    #   origins.map! { |url| /#{url}/ }
    #   config.action_cable.allowed_request_origins = origins
    # end

    # Disable Asset Pipeline/Sprockets
    # config.assets.enabled = false
    # config.assets.compile = false

    # Use a real queuing backend for Active Job (and separate queues per environment)
    config.active_job.queue_adapter      = :sidekiq

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.generators.javascripts = false
    config.generators.stylesheets = false

    ################################################################

    # Auto load path
    config.autoload_paths += [
      Rails.root.join('lib')
    ]

    # config.eager_load_paths += %W(
    #   #{config.root}/lib
    # )

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Disable yarn check(this must disable with docker)
    # config.webpacker.check_yarn_integrity = false

    # Manage exception page
    # config.exceptions_app = self.routes
  end

  def self.config
    @config ||= Rails.configuration.x
  end
end

require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OrganizerService
  class Application < Rails::Application
    Rails.application.config.middleware.delete Rack::Lock
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths << "#{Rails.root}/app/exceptions"
    config.api_only = true
    config.active_job.queue_adapter = :sidekiq unless Rails.env.test?
  end
end

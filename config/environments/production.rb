Rails.application.configure do
  config.action_controller.perform_caching = true
  config.action_mailer.perform_caching = false
  config.active_record.dump_schema_after_migration = false
  config.active_support.deprecation = :notify
  config.assets.compile = false
  config.assets.digest = true
  config.assets.js_compressor = :uglifier
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.eager_load = true
  config.log_formatter = ::Logger::Formatter.new
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.i18n.fallbacks = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  end

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store
end

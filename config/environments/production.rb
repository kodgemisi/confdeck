Confman::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( bootstrap.js bootstrap-custom.css font-awesome.min.css home.css timeline.css home.js schedule.js conferences.js jquery.js organizations.js speakers.js speeches.js invitations.js rooms.js slots.js sponsors.js topics.js conference_landing.css conference_landing.js iconfont.css)

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'www.confdeck.com' }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      :address              => "smtp.yandex.ru",
      :port                 => 587,
      :domain               => 'confdeck.com',
      :user_name            => Rails.application.secrets.smtp["user"],
      :password             => Rails.application.secrets.smtp["password"],
      :authentication       => "plain",
      :enable_starttls_auto => true
  }
  #config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
  Rails.application.routes.default_url_options[:host] = 'www.confdeck.com'

  config.paperclip_defaults = {
      :storage => :s3,
      :s3_credentials => {
          :bucket => 'confdeck.com'
      },
      :s3_host_name => "s3-eu-central-1.amazonaws.com"
  }

  AWS.config(logger: Rails.logger)
  AWS.config(log_level: :debug)
  AWS.config(access_key_id: Rails.application.secrets.s3["access_id"], secret_access_key: Rails.application.secrets.s3["secret_key"], region: 'eu-central-1')

end

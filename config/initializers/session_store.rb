if Rails.env == 'production'
  Rails.application.config.session_store :cookie_store, key: "_trading_simulator", domain: "production app domain.com"
else
  Rails.application.config.session_store :cookie_store, key: "_trading_simulator"
end

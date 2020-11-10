Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins are set in the environment files
    origins Rails.application.config.allowed_cors_origins
    resource '*', headers: :any, methods: %i[get post put patch head options delete]
  end
end

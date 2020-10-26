module Volunteers
  class RootApi < Grape::API
    format :json

    # before { authenticate_client_app! }

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error!('Bad request', 400)
    end

    rescue_from ActiveRecord::RecordNotFound do
      error!('Not Found', 404)
    end

    http_basic do |username, password|
      ENV['SWAGGER_USERNAME'] == username && ENV['SWAGGER_PASSWORD'] == password
    end

    # mount ProfilesApi

    add_swagger_documentation(
      format: :json,
      base_path: '/volunteers/api/v1',
      mount_path: 'docs',
      info: { title: 'Volunteers API docs' },
      models: [],
      array_use_braces: true,
      add_root: true
    )
  end
end

module HelpSeekers
  class RootApi < Grape::API
    format :json

    helpers HelpSeekers::Helpers

    rescue_from Grape::Knock::ForbiddenError do
      error!('Forbidden', 403)
    end

    rescue_from Grape::Exceptions::ValidationErrors do
      error!('Bad request', 400)
    end

    rescue_from ActiveRecord::RecordNotFound do
      error!('Not Found', 404)
    end

    # http_basic do |username, password|
    #   ENV['SWAGGER_USERNAME'] == username && ENV['SWAGGER_PASSWORD'] == password
    # end

    mount NeedsApi
    mount Common::ProfileApi

    add_swagger_documentation(
      format: :json,
      base_path: '/help_seekers/api/v1',
      mount_path: 'docs',
      info: { title: 'HelpSeekers API docs' },
      models: [],
      array_use_braces: true,
      add_root: true,
      security: [{ AuthBearerToken: [] }],
      security_definitions: {
        AuthBearerToken: {
          type: 'apiKey',
          name: 'Authorization',
          in: 'header'
        }
      }
    )
  end
end

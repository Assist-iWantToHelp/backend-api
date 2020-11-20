module Common
  class RootApi < Grape::API
    format :json

    rescue_from ActiveRecord::RecordNotFound do
      error!('Not Found', 404)
    end

    mount NeedsApi
    mount SpecialCasesApi
    mount SuggestionsApi
    mount TestimonialsApi
    mount VolunteersApi

    add_swagger_documentation(
      format: :json,
      base_path: '/public/api/v1',
      mount_path: 'docs',
      info: { title: 'Public API docs' },
      models: [],
      array_use_braces: true,
      add_root: true
    )
  end
end

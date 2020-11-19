module Common
  class SuggestionsApi < Grape::API
    resource :suggestions do
      desc 'Create new SuggestionsApi' do
        tags %w[suggestions]
        http_codes [
          { code: 201, model: Entities::Suggestion, message: 'Suggestion created' },
          { code: 400, message: 'Params are invalid' }
        ]
      end
      params do
        with(documentation: { in: 'body' }) do
          requires :email, type: String, desc: 'Email', allow_blank: false
          requires :name, type: String, desc: 'Name', allow_blank: false
          requires :message, type: String, desc: 'Message', allow_blank: false
        end
      end
      post do
        suggestion = Suggestion.create!(params)
        present suggestion, with: Entities::Suggestion
      end
    end
  end
end

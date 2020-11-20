module Common
  class NeedsApi < Grape::API
    resource :needs do
      desc 'Needs' do
        tags %w[needs]
        http_codes [
          { code: 200, model: Entities::Need, message: 'Needs list' }
        ]
      end
      get do
        needs = Need.all
        present needs, with: Entities::Need
      end
    end
  end
end

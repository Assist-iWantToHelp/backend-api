module HelpSeekers
  class NeedsApi < Grape::API
    use Grape::Knock::Authenticable

    resource :my_needs do
      desc 'Get my needs' do
        tags %w[needs]
        http_codes [
          { code: 200, model: Entities::Need, message: 'Needs list' }
        ]
      end
      get do
        # TODO - add sign_in on swagger
        needs = current_user.my_needs
        present needs, with: Entities::Need
      end
    end
  end
end

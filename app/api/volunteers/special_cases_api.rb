module Volunteers
  class SpecialCasesApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    resource :special_cases do
      desc "My special cases" do
        tags %w[special_cases]
        http_codes [
          { code: 200, model: Entities::SpecialCase, message: "My special cases list" }
        ]
      end
      get do
        special_cases = SpecialCase.all.where(user: current_user, deleted: false)
        present special_cases, with: Entities::SpecialCase
      end

      route_param :id do
        desc 'Get specific special case' do
          tags %w[special_cases]
          http_codes [
            { code: 200, model: Entities::SpecialCase, message: 'Special case description' },
            { code: 404, message: 'Special case not found' }
          ]
        end
        get do
          special_case = SpecialCase.all.where(user: current_user, deleted: false).find(params[:id])
          present special_case, with: Entities::SpecialCase
        end

        desc 'Delete special case' do
          tags %w[special_cases]
          http_codes [
            { code: 204, message: 'No content' },
            { code: 400, message: 'Special case is not opened anymore' },
            { code: 404, message: 'Special case not found' }
          ]
        end
        delete do
          special_case = current_user.special_cases.find(params[:id])
          if special_case.opened?
            special_case.update!(deleted: true)
            status :no_content
          else
            status :bad_request
            error!('Special case is not opened anymore', 400)
          end
        end
      end
    end
  end
end

module Volunteers
  class SpecialCasesApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    resource :special_cases do
      desc 'My special cases' do
        tags %w[special_cases]
        http_codes [
          { code: 200, model: Entities::SpecialCase, message: 'My special cases list' }
        ]
      end
      get do
        special_cases = current_user.special_cases.not_deleted
        present special_cases, with: Entities::SpecialCase
      end

      desc 'Create new special case' do
        tags %w[special_cases]
        http_codes [
          { code: 201, model: Entities::SpecialCase, message: 'Special case created' },
          { code: 400, message: 'Params are invalid' }
        ]
      end
      params do
        with(documentation: { in: 'body' }) do
          requires :description, type: String, desc: 'Description', allow_blank: false
        end
      end
      post do
        special_case = current_user.special_cases.create!(params)
        present special_case, with: Entities::SpecialCase
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
          special_case = current_user.special_cases.not_deleted.find(params[:id])
          present special_case, with: Entities::SpecialCase
        end

        desc 'Edit specific special case' do
          tags %w[special_cases]
          http_codes [
            { code: 200, model: Entities::SpecialCase, message: 'Special case updated' },
            { code: 400, message: 'Params are invalid' },
            { code: 404, message: 'Special case not found' },
            { code: 409, message: 'Special case is not opened anymore' }
          ]
        end
        params do
          with(documentation: { in: 'body' }) do
            optional :description, type: String, desc: 'Description', allow_blank: false
          end
        end
        put do
          special_case = current_user.special_cases.not_deleted.find(params[:id])

          if special_case.opened?
            special_case.update!(params)
            present special_case, with: Entities::SpecialCase
          else
            error!('Special case is not opened anymore', 409)
          end
        end

        desc 'Delete special case' do
          tags %w[special_cases]
          http_codes [
            { code: 204, message: 'No content' },
            { code: 404, message: 'Special case not found' },
            { code: 409, message: 'Special case is not opened anymore' }
          ]
        end
        delete do
          special_case = current_user.special_cases.find(params[:id])
          if special_case.opened?
            special_case.update!(deleted: true)
            status :no_content
          else
            error!('Special case is not opened anymore', 409)
          end
        end
      end
    end
  end
end

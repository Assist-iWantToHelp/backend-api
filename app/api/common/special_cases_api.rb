module Common
  class SpecialCasesApi < Grape::API
    resource :special_cases do
      desc 'Special cases' do
        tags %w[special_cases]
        http_codes [
          { code: 200, model: Entities::SpecialCase, message: 'Special cases list' }
        ]
      end
      get do
        special_cases = SpecialCase.not_deleted
        present special_cases, with: Entities::SpecialCase
      end
    end
  end
end

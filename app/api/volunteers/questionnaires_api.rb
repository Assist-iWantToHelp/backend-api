module Volunteers
  class QuestionnairesApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    resource :questionnaires do
      desc 'Complete questionnaire' do
        tags %w[questionnaires]
        http_codes [
          { code: 201, message: 'Questionnaire completed' },
          { code: 400, message: 'Params are invalid' }
        ]
      end
      params do
        with(documentation: { in: 'body' }) do
          requires :answear_1, type: Integer, desc: 'Answear 1', allow_blank: false
          requires :answear_2, type: Integer, desc: 'Answear 2', allow_blank: false
          requires :answear_3, type: Integer, desc: 'Answear 3', allow_blank: false
          requires :answear_4, type: Integer, desc: 'Answear 4', allow_blank: false
          requires :answear_5, type: Integer, desc: 'Answear 5', allow_blank: false
        end
      end
      post do
        params[:user_id] = current_user.id
        testimonial = Questionnaire.create!(params) # encrpyt answears
        status :created
      end
    end
  end
end

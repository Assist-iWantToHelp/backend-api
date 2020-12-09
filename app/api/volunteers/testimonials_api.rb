module Volunteers
  class TestimonialsApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    resource :testimonials do
      desc 'Add testimonial' do
        tags %w[testimonials]
        http_codes [
          { code: 201, model: Entities::Testimonial, message: 'Testimonial created' },
          { code: 400, message: 'Params are invalid' }
        ]
      end
      params do
        with(documentation: { in: 'body' }) do
          requires :message, type: String, desc: 'Message', allow_blank: false
        end
      end
      post do
        params[:user_id] = current_user.id
        testimonial = Testimonial.create!(params)
        present testimonial, with: Entities::Testimonial
      end

      desc 'Get testimonial' do
        tags %w[testimonials]
        http_codes [
          { code: 200, model: Entities::Testimonial, message: 'Testimonial details' },
          { code: 404, message: 'Testimonial not found' }
        ]
      end
      get do
        testimonial = current_user.testimonial

        if testimonial
          present testimonial, with: Entities::Testimonial
        else
          { testimonial: {} }
        end
      end
    end
  end
end

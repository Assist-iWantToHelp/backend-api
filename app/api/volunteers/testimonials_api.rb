module Volunteers
  class TestimonialsApi < Grape::API
    use Grape::Knock::Authenticable

    resource :testimonials do
      desc 'Add testimonial' do
        tags %w[testimonials]
        http_codes [
          { code: 200, model: Entities::Testimonial, message: 'Testimonial list' }
        ]
      end
      params do
        with(documentation: { in: 'body' }) do
          requires :message, type: String, desc: 'Message', allow_blank: false
        end
      end
      post do
        testimonial = current_user.testimonial.create!(params)
        present testimonial, with: Entities::Testimonial
      end
    end
  end
end
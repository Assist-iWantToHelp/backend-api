module Common
  class TestimonialsApi < Grape::API
    resource :testimonials do
      desc 'Testimonials' do
        tags %w[testimonials]
        http_codes [
          { code: 200, model: Entities::Testimonial, message: 'Testimonials list' }
        ]
      end
      get do
        testimonials = Testimonial.all
        present testimonials, with: Entities::Testimonial
      end
    end
  end
end

module Volunteers
  module Entities
    class Volunteer < Common::Entities::User
      expose :email
      expose :cif
    end

    class HelpSeeker < Common::Entities::User
      expose :email
    end

    class Need < Common::Entities::Need
      expose :added_by, using: HelpSeeker, expose_nil: true
      expose :reviews, using: Common::Entities::Review, expose_nil: true
    end

    class RecommendedNeed < Need
      expose :contact_info
      expose :contact_phone_number
      expose :chosen_by, using: Volunteer, expose_nil: true
    end

    class Testimonial < Grape::Entity
      root :testimonials, :testimonial

      expose :id, documentation: { type: Integer }
      expose :message
    end
  end
end

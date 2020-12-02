module Volunteers
  module Entities
    class Volunteer < Common::Entities::User
      expose :email
      expose :cif
    end

    class BasicHelpSeeker < Common::Entities::User
      expose :email
    end

    class HelpSeeker < BasicHelpSeeker
      expose :provided_reviews, using: Common::Entities::Review, expose_nil: true
      expose :received_reviews, using: Common::Entities::Review, expose_nil: true
    end

    class BasicNeed < Common::Entities::BasicNeed
      expose :person_name
      expose :street_name
    end

    class Need < Common::Entities::Need
      expose :added_by, using: BasicHelpSeeker, expose_nil: true
      expose :contact_first_name
      expose :contact_last_name
      expose :contact_phone_number
      expose :address, using: Common::Entities::Address, expose_nil: true
      expose :reviews, using: Common::Entities::Review, expose_nil: true
    end

    class RecommendedNeed < Need
      expose :chosen_by, using: Volunteer, expose_nil: true
    end

    class Testimonial < Grape::Entity
      root :testimonials, :testimonial

      expose :id, documentation: { type: Integer }
      expose :message
    end

    class SpecialCase < Common::Entities::SpecialCase
    end
  end
end

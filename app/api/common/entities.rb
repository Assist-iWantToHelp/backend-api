module Common
  module Entities
    class PublicUser < Grape::Entity
      expose :first_name
      expose :last_name
      expose :role
    end

    class User < PublicUser
      expose :phone_number
    end

    class Address < Grape::Entity
      expose :street_name
      expose :city
      expose :county
      expose :postal_code
      expose :coordinates
      expose :details
    end

    class Profile < User
      expose :email
      expose :address, using: Address, expose_nil: true
    end

    class Need < Grape::Entity
      root :needs, :need

      expose :id, documentation: { type: Integer }
      expose :description
      expose :status
    end

    class PublicReview < Grape::Entity
      root :reviews, :review

      expose :stars, documentation: { type: Integer }
      expose :comment
    end

    class Review < PublicReview
      expose :provided_by, using: User, expose_nil: true
      expose :given_to, using: User, expose_nil: true
    end

    class Suggestion < Grape::Entity
      expose :email
      expose :name
      expose :message
    end

    class Testimonial < Grape::Entity
      expose :user, using: PublicUser
      expose :message
    end

    class Volunteer < PublicUser
      expose :given_reviews, using: PublicReview, as: :reviews
    end

    class SpecialCase < Grape::Entity
      expose :description
      expose :status
      expose :added_by, using: PublicUser
    end
  end
end

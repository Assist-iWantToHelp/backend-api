module Common
  module Entities
    class Address < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :street_name
      expose :city
      expose :county
      expose :postal_code
      expose :coordinates
      expose :details
    end

    class PublicUser < Grape::Entity
      root :users, :user

      expose :id, documentation: { type: Integer }
      expose :first_name
      expose :last_name
      expose :role
      expose :description
      expose :received_rating, as: :rating, documentation: { type: Float }
      expose :address, using: Address, expose_nil: true
    end

    class User < PublicUser
      expose :phone_number
    end

    class Profile < User
      root :profiles, :profile

      expose :email
      expose :questionnaire_completed, if: ->(user, _) { user.volunteer? }, documentation: { type: 'boolean' }
      expose :trusted_volunteer, if: ->(user, _) { user.volunteer? }, documentation: { type: 'boolean' }
    end

    class BasicNeed < Grape::Entity
      root :needs, :need

      expose :id, documentation: { type: Integer }
      expose :description
      expose :category
      expose :status
      expose :status_updated_at, documentation: { type: DateTime }
    end

    class Need < BasicNeed
      expose :updated_by, using: User, expose_nil: true
    end

    class PublicReview < Grape::Entity
      root :reviews, :review

      expose :id, documentation: { type: Integer }
      expose :stars, documentation: { type: Integer }
      expose :comment
      expose :created_at, documentation: { type: DateTime }
    end

    class Review < PublicReview
      expose :provided_by, using: User, expose_nil: true
      expose :given_to, using: User, expose_nil: true
    end

    class Suggestion < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :email
      expose :name
      expose :message
    end

    class Testimonial < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :user, using: PublicUser
      expose :message
    end

    class Volunteer < PublicUser
      expose :received_reviews, using: PublicReview, as: :reviews
    end

    class SpecialCase < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :description
      expose :status
      expose :added_by, using: PublicUser
    end

    class Device < Grape::Entity
      expose :signal_id
    end
  end
end

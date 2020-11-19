module Common
  module Entities
    class User < Grape::Entity
      expose :phone_number
      expose :first_name
      expose :last_name
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
      expose :status_updated_at, documentation: { type: DateTime }
      expose :updated_by, using: User, expose_nil: true
    end

    class Review < Grape::Entity
      root :reviews, :review

      expose :stars, documentation: { type: Integer }
      expose :comment
      expose :provided_by, using: User, expose_nil: true
      expose :given_to, using: User, expose_nil: true
    end

    class Suggestion < Grape::Entity
      expose :email
      expose :name
      expose :message
    end
  end
end

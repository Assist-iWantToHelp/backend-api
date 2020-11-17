module Common
  module Entities
    class User < Grape::Entity
      expose :phone_number
      expose :first_name
      expose :last_name
    end

    class Profile < User
      expose :email
    end

    class Need < Grape::Entity
      root :needs, :need

      expose :id, documentation: { type: Integer }
      expose :description
      expose :status
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

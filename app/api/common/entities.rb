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
  end
end

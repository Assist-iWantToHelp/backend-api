module Common
  module Entities
    class User < Grape::Entity
      expose :phone_number
      expose :first_name
      expose :last_name
      expose :email
      expose :cif
      expose :role
    end

    class Need < Grape::Entity
      root :needs, :need

      expose :id, documentation: { type: Integer }
      expose :description
      expose :state
      expose :contact_info
      expose :contact_phone_number
      expose :added_by, using: User
      expose :created_by, using: User
    end
  end
end

module HelpSeekers
  module Entities
    class Volunteer < Common::Entities::User
    end

    class HelpSeeker < Common::Entities::User
      expose :email
    end

    class Need < Common::Entities::Need
      expose :chosen_by, using: Volunteer, expose_nil: true
    end
  end
end

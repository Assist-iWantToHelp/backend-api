module HelpSeekers
  module Entities
    class PublicReview < Common::Entities::PublicReview
      expose :provided_by, using: Common::Entities::PublicUser
    end

    class Volunteer < Common::Entities::User
      expose :received_reviews, using: PublicReview, as: :reviews
    end

    class Need < Common::Entities::Need
      expose :chosen_by, using: Volunteer, expose_nil: true
      expose :reviews, using: Common::Entities::Review
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :need do
    added_by { FactoryBot.create(:user, :as_help_seeker) }
    description { Faker::Lorem.sentence }

    trait :in_progress do
      chosen_by { FactoryBot.create(:user, :as_volunteer) }
      status { Need.statuses[:in_progress] }
    end
  end
end

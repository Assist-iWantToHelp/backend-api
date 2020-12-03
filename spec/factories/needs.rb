# frozen_string_literal: true

FactoryBot.define do
  factory :need do
    added_by { FactoryBot.create(:user, :as_help_seeker) }
    description { Faker::Lorem.sentence }

    trait :in_progress do
      chosen_by { FactoryBot.create(:user, :as_volunteer) }
      status { Need.statuses[:in_progress] }
      updated_by { chosen_by }
      status_updated_at { DateTime.current }
    end

    trait :recommended do
      added_by { FactoryBot.create(:user, :as_volunteer) }
      contact_first_name { Faker::Name.first_name }
      contact_last_name { Faker::Name.last_name }
      contact_phone_number { Faker::PhoneNumber.cell_phone }
      address { association :address }
    end
  end
end

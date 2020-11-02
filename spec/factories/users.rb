# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    phone_number { Faker::PhoneNumber.cell_phone }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    address { association :address, user: instance }

    trait :as_help_seeker do
      role { 0 }
    end

    trait :as_volunteer do
      role { 1 }
    end

    trait :as_ngo do
      cif { Faker::Number.number(digits: 6) }
      role { 2 }
    end

    trait :as_admin do
      role { 3 }
    end
  end
end

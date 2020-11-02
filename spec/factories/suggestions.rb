# frozen_string_literal: true

FactoryBot.define do
  factory :suggestion do
    message { Faker::Lorem.sentence }
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
  end
end

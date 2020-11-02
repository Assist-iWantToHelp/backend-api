# frozen_string_literal: true

FactoryBot.define do
  factory :special_case do
    user { FactoryBot.create(:user) }
    description { Faker::Lorem.sentence }
  end
end

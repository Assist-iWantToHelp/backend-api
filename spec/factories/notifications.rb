# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    user { FactoryBot.create(:user) }
    description { Faker::Lorem.sentence }
  end
end

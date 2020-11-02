# frozen_string_literal: true

FactoryBot.define do
  factory :user_special_case do
    user { FactoryBot.create(:user) }
    special_case { FactoryBot.create(:special_case) }
    promotion_description { Faker::Lorem.sentence }
  end
end

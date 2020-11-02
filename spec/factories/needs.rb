# frozen_string_literal: true

FactoryBot.define do
  factory :need do
    added_by { FactoryBot.create(:user) }
    chosen_by { FactoryBot.create(:user) }
    description { Faker::Lorem.sentence }
  end
end

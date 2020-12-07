# frozen_string_literal: true

FactoryBot.define do
  factory :device do
    user { FactoryBot.create(:user) }
    signal_id { Faker::Internet.uuid }
  end
end

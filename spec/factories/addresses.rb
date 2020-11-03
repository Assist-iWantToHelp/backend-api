# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    street_name { Faker::Address.street_name }
    city { Faker::Address.city }
    county { Faker::Address.state }
    postal_code { Faker::Address.zip }
    coordinates { "#{Faker::Address.latitude}, #{Faker::Address.longitude}" }
  end
end

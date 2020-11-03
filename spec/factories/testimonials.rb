# frozen_string_literal: true

FactoryBot.define do
  factory :testimonial do
    message { Faker::Lorem.sentence }
    user { association :user, testimonial: instance }
  end
end

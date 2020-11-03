# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    provided_by { FactoryBot.create(:user) }
    given_to { FactoryBot.create(:user) }
    need { FactoryBot.create(:need) }
    stars { Faker::Number.within(range: 1..5) }
    comment { Faker::Lorem.sentence }
  end
end

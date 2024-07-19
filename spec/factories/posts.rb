# frozen_string_literal: true

FAKER_RANDOM_NUM = 42
Faker::Config.random = Random.new(FAKER_RANDOM_NUM)

FactoryBot.define do
  factory :post do
    association :user
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
  end
end

# frozen_string_literal: true

module PostFactoryConstants
  FAKER_RANDOM_NUM = 42
end

Faker::Config.random = Random.new(PostFactoryConstants::FAKER_RANDOM_NUM)

FactoryBot.define do
  factory :post do
    association :user
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
  end
end

# frozen_string_literal: true

module CommentFactoryConstants
  FAKER_RANDOM_NUM = 1
end

Faker::Config.random = Random.new(CommentFactoryConstants::FAKER_RANDOM_NUM)

FactoryBot.define do
  factory :comment do
    association :user
    association :post
    comment { Faker::Lorem.paragraph }
  end
end

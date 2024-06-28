# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    association :user
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
  end
end

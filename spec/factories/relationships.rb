# frozen_string_literal: true

FactoryBot.define do
  factory :relationship do
    association :follower, factory: :user
    association :followee, factory: :user
  end
end

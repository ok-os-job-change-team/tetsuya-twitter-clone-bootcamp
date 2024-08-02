# frozen_string_literal: true

FactoryBot.define do
  factory :tree_path do
    association :ancestor,   factory: :comment
    association :descendant, factory: :comment
  end
end

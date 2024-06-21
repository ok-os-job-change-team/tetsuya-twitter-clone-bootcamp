# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'user1@example.com' }
    password { 'p@ssw0rd' }
    password_confirmation { 'p@ssw0rd' }
  end

  factory :other_user, class: 'User' do
    email { 'other_user@example.com' }
    password { 'otherp@ssw0rd' }
    password_confirmation { 'otherp@ssw0rd' }
  end
end

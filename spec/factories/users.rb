FactoryBot.define do
  factory :user do
    id { 1 }
    email { 'user1@example.com' }
    password { 'p@ssw0rd' }
  end
end

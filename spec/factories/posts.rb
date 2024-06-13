# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { 'サンプルタイトル' }
    content { 'サンプル記事' }
  end
end

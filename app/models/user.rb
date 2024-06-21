# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: true

  has_many :posts, dependent: :destroy

  has_secure_password
end

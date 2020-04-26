class User < ApplicationRecord
  has_one :portfolio

  has_secure_password
  validates :email, uniqueness: true, presence: true
end

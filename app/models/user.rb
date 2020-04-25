class User < ApplicationRecord
  has_secure_password

  validates_presence_of :user_name
  validates_uniqueness_of :user_name
end

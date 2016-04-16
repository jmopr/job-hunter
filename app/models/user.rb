class User < ActiveRecord::Base
  validates :username, uniqueness: true
  has_many :jobs
  has_secure_password
end

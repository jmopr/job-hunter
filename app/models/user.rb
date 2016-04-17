class User < ActiveRecord::Base
  validates :first_name, :last_name, :email, :phone_number, presence: true
  validates :username, uniqueness: true
  has_many :jobs
  has_secure_password
end

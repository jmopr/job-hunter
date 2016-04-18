class User < ActiveRecord::Base
  validates :first_name, :last_name, :email, :phone_number, presence: true
  validates :first_name, :last_name, length: { in: 2..20 }
  validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/,
    message: "only allows letters" }
  validates :phone_number, format: { with: /\d{3}-\d{3}-\d{4}/, message: "bad format" }
  validates :username, uniqueness: true
  has_many :jobs
  has_secure_password
end

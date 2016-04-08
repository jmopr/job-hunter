class User < ActiveRecord::Base
  has_many :jobs
  has_secure_password
end

class Job < ActiveRecord::Base
  belongs_to :user
  validates :title, :company, :post_date, :description, presence: true
end

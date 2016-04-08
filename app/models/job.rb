class Job < ActiveRecord::Base
  validates :title, :company, :post_date, :description, presence: true

  
end

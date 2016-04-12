class Job < ActiveRecord::Base
  belongs_to :user
  # validates :title, :company, :description, presence: true

  scope :match, -> { where('score > 50') }

  # Apply for the matching jobs.
  def self.apply(jobs)
    jobs.each do |job|
      %x(bin/rails runner applier.rb #{job.url})
    end
  end
end

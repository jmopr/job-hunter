class Job < ActiveRecord::Base
  belongs_to :user
  # validates :title, :company, :description, presence: true

  scope :match, -> { where('score > 50') }

  # Searches for jobs.
  def self.get_jobs
    %x(bin/rails runner scraper.rb)
  end

  # Apply for the matching jobs.
  def self.apply(jobs)
    jobs.each do |job|
      %x(bin/rails runner applier.rb #{job.url})
    end
  end
end

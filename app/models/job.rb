class Job < ActiveRecord::Base
  belongs_to :user
  validates :title, :company, :description, presence: true
  validates :title, uniqueness: true, on: :create

  scope :match, -> { where('score > 50') }

  # Searches for jobs.
  def self.get_jobs
    %x(bin/rails r scraper.rb)
  end

  # Apply for the matching jobs.
  def self.apply(jobs)
    jobs.each do |job|
      %x(bin/rails r applier.rb #{job.url})
    end
  end
end

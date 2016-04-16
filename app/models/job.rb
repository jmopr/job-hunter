class Job < ActiveRecord::Base
  belongs_to :user
  validates :title, :company, :description, presence: true
  validates :title, uniqueness: true, on: :create

  scope :match, -> { where('score > 50') }
  scope :applied, -> { where(applied: true) }

  def self.logo_validator(url)
    res = Faraday.get("https://logo.clearbit.com/#{url}")
    unless res.status == 200
      "https://placeholdit.imgix.net/~text?txtsize=33&txt=400%C3%97400&w=400&h=400"
    else
      "https://logo.clearbit.com/#{url}"
    end
  end

  def self.autocomplete(name)
    res = Faraday.get("https://autocomplete.clearbit.com/v1/companies/suggest?query=:#{name}")
    url = JSON.parse(res.body)[0]["domain"]
    Job.logo_validator(url)
  end

  # Searches for jobs.
  def self.get_jobs(title, location)
    %x(bin/rails r scraper.rb "#{title}" "#{location}")
  end

  # Apply for the matching jobs.
  def self.apply(jobs)
    jobs.each do |job|
      %x(bin/rails r applier.rb #{job.id})
    end
  end
end

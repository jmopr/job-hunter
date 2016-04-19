class Job < ActiveRecord::Base
  belongs_to :user
  validates :title, :company, :description, presence: true
  validates :title, :company, uniqueness: true

  scope :match, -> { where('score > 50') }
  scope :applied, -> { where('applied: true') }

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
    rescue
      "https://placeholdit.imgix.net/~text?txtsize=33&txt=400%C3%97400&w=400&h=400"
  end

  # Searches for jobs.
  def self.get_jobs(user, title, location, pages)
    %x(bin/rails r scraper.rb "#{user.id}" "#{title}" "#{location}" "#{pages}")
  end

  # Apply for the matching jobs.
  def self.apply(user, jobs)
    jobs.each do |job|
      unless job.applied
        %x(bin/rails r applier.rb "#{user.id}" "#{job.id}")
      end
    end
  end
end


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
  def self.get_jobs(user, title, location)
    %x(bin/rails r scraper.rb "#{user.id}" "#{title}" "#{location}")
  end

  # Apply for the matching jobs.
  def self.apply(user, jobs)
    jobs.each do |job|
      %x(bin/rails r applier.rb "#{user.id}" "#{job.id}")
    end
  end

  def get_number_of_repos(user_name)
    response = HTTParty.get("https://api.github.com/users/#{user_name}/repos")
    number = response.length
    names_of_projects =[]
    (0..number-1).each do |i|
      names_of_projects << response[i]["name"]
    end
    names_of_projects
  end
  def get_the_bytes(user_name)
    names = get_number_of_repos(user_name)
    ruby_bytes = []
    lines = []
    names.each do |name|
      response = HTTParty.get("https://api.github.com/repos/#{user_name}/#{name}/languages")
      ruby_bytes << response["Ruby"]
    end
    ruby_bytes.each do |project|
      unless project == nil
        lines << project/40
      end
    end
    lines.reduce(:+)
  end
end

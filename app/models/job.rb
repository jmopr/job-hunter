class Job < ActiveRecord::Base
  belongs_to :user
  validates :title, :company, :description, presence: true
  validates_uniqueness_of :title, scope: [:company, :url, :description]
  paginates_per 25

  scope :match, -> { where('score > 40') }
  scope :applied, -> { where('applied = ?', true) }

  def self.hex(id)
    Digest::MD5.hexdigest id
  end

  def to_param
    hex_id
  end

  def self.logo_validator(url)
    res = Faraday.get("https://logo.clearbit.com/#{url}")
    unless res.status == 200
      "https://placeholdit.imgix.net/~text?txtsize=22&txt=I+was+unable+to+find+your+logo+sorry&w=140&h=140&txttrack=0"
    else
      "https://logo.clearbit.com/#{url}"
    end
  end

  def self.autocomplete(name)
    res = Faraday.get("https://autocomplete.clearbit.com/v1/companies/suggest?query=:#{name}")
    url = JSON.parse(res.body)[0]["domain"]
    Job.logo_validator(url)
    rescue
      "https://placeholdit.imgix.net/~text?txtsize=22&txt=I+was+unable+to+find+your+logo+sorry&w=140&h=140&txttrack=0"
  end

  # Searches for jobs.
  def self.get_jobs(scraper, user, title = "", location = "", pages = "")
    %x(bin/rails r #{scraper}.rb "#{user.id}" "#{title}" "#{location}" "#{pages}")
  end

  # Apply for the matching jobs.
  def self.apply(user, jobs, applier)
    jobs.each do |job|
      unless job.applied
        %x(bin/rails r #{applier}.rb "#{user.id}" "#{job.id}")
      end
    end
  end
end

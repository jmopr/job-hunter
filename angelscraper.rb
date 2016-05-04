require 'capybara/dsl'
require 'capybara-webkit'
require 'cgi'
require 'byebug'
require 'json'
require 'timeout'
require 'capybara'
require './matcher'
require 'dotenv'
Dotenv.load

class JobScraper
  include Capybara::DSL

  def initialize(url, userID)
    # Capybara.default_driver = :webkit
    # Capybara.javascript_driver = :webkit
    Capybara.default_driver = :selenium
    Capybara.javascript_driver = :selenium
    Capybara::Webkit.configure do |config|
      config.allow_url("http://www.angel.co")
      config.block_unknown_urls
    end
    @job_links = []
    @url = url
    @user = User.find(userID)
  end

  def scrape(skills, location)
    visit @url
    page.find('.home_ctas.home_talent_jobs_button.g-button.larger.blue', match: :first).click
    login
    # Added to remove Florida (optional)
    find("img[data-value='Florida']", match: :first).click
    sleep(1)
    find("img[data-value='Software Engineer']", match: :first).click
    sleep(1)

    fill_info(skills, location)
    sleep(1)
    get_jobs
    create_jobs
  end

  def login
    # using angel account
    log_link = page.find_link('Log in').click
    fill_in 'user[email]', :with => @user.email
    fill_in 'user[password]', :with => ENV['ANGEL_KEY']
    page.find("input[name='commit']").click
  end

  def fill_info(skills, location)
    page.find('.fontello-search.magnifying-glass').click

    field = find(".input.keyword-input")
    field.set "#{skills}\n"

    field1 = find(".input.keyword-input")
    field1.set "#{location}\n"

    page.find('.save-current-filters.g-button.light.smaller', match: :first).click
    page.find('.save_filter_link.g-button.blue', match: :first).click
  end

  def get_jobs
    now = Time.now
    counter = 1
    # gets to the end of the page to accumulate companies
    until page.has_selector?('.end.hidden.section', :visible => true) || page.has_selector?('.none_notice')
      if Time.now < now + counter
        next
      else
        page.execute_script "window.scrollBy(0, 10000)"
      end
      counter += 1
      break if counter > 20
    end

    company_sections = all('.djl87.job_listings.fbe70.browse_startups_table._a._jm')
    company_sections.each do |company_section|
      companies = all('.djl87.job_listings.fbw9.browse_startups_table_row._a._jm')
      companies.each do |company|
        # jobs codes on each company in array format
        company_url = company.find('.startup-link')['href']

        job_ids = JSON.parse company['data-listing-ids']
        job_ids.each do |job_id|
          job_url = "#{company_url}/#{job_id}"
          @job_links << job_url
        end
      end
    end
  end

  def create_jobs
    gather_requirements do |job_reqs, link|
      puts "Currently on #{link}"
      match = matching_algorithm(job_reqs).round(2)

      job_title = page.first("h1.u-colorGray3").text.split(' at ')
      company = job_title.last
      if page.has_css?('.high-concept.u-fontSize20.u-fontWeight200.u-colorGray6')
        location = page.find('.high-concept.u-fontSize20.u-fontWeight200.u-colorGray6').text.split('·').first
      elsif page.has_css?('.u-floatLeft')
        location = page.find('.u-floatLeft').split(" in ").last
      end

      job = Job.create(title: job_title.first,
                 description: job_reqs.join(" "),
                 company: company,
                 location: location,
                 post_date: Date.today,
                 url: page.current_url,
                 score: match,
                 applied: false,
                 user_id: @user.id
      )

      if match > 40
        if page.has_css?('.website-link')
          company_url = page.find('.website-link')['href'].gsub(/https?\:/, '').gsub(/\//, '')
          job.update(logo: "https://logo.clearbit.com/#{company_url}")
        else
          job.update(logo: Job.autocomplete(company))
        end
      end
      job.update(hex_id: Job.hex(job.id.to_s))
    end
  end

  def gather_requirements
    @job_requirements = {}
    # visit the job listing page for a given job
    @job_links.each do |link|
      visit link
      # in the job listings page we opened in a new tab print the job description
      reqs = extract_requirements
      if reqs != nil
        if block_given?
          yield reqs, link
        else
          @job_requirements[link] = matching_algorithm(reqs)
        end
      end
    end
    @job_links = []
    @job_requirements unless block_given?
  end

  def extract_requirements
    if page.has_selector?(".job-description")
      page.find(".job-description").text.split('.')
    end
  end
end

JobScraper.new('http://www.angel.co', ARGV[0]).scrape(ARGV[1], ARGV[2])

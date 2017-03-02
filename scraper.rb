require 'capybara/dsl'
require 'capybara-webkit'
require 'cgi'
require 'timeout'
require 'capybara'
require './matcher'

class JobScraper
  include Capybara::DSL

  def initialize(url, userID, pages)
    Capybara.default_driver = :webkit
    Capybara.javascript_driver = :webkit
    # Capybara.default_driver = :selenium
    # Capybara.javascript_driver = :selenium
    Capybara::Webkit.configure do |config|
      config.allow_url("www.indeed.com")
      config.block_unknown_urls
    end
    @job_links = []
    @url = url
    @user = User.find(userID)
    @counter = 1
    @pages = pages.to_i
  end

  def scrape(skillset, region)
    @skillset = skillset
    @region = region

    visit @url
    sleep(1)
    perform_search
    search_jobs
  end

  def search_jobs
    close_modal
    filter_jobs

    gather_requirements do |job_reqs|
      match = matching_algorithm(job_reqs).round(2)
      company = page.first(".company").text.downcase
      job = Job.create(title: page.first(".jobtitle").text,
                 description: job_reqs.join(" "),
                 company: company,
                 location: page.first(".location").text,
                 post_date: page.first(".date").text,
                 url: page.current_url,
                 score: match,
                 applied: false,
                 user_id: @user.id
      )
      if match > 40
        job.update(logo: Job.autocomplete(company))
      end
      job.update(hex_id: Job.hex(job.id.to_s))
    end
    @counter += 1
    if @counter <= @pages
      next_page
    end
  end

  def next_page
    if page.find('.np', match: :first).text == "Next »"
      continue = page.find('.np', match: :first)
    elsif page.all('.np').length > 1
      continue = page.all('.np')[1]
    else
      continue = "stop"
    end
    unless continue == "stop"
      next_link = continue.find(:xpath, '../..')
      next_link.click
      sleep(1)
      if page.has_selector?('.popover-x-span')
        page.find('.popover-x-span').click
      end
      sleep(1)
      search_jobs
    end
  end

  def gather_requirements
    @job_requirements = {}
    # visit the job listing page for a given job
    @job_links.each do |link|
      # get a handle on the new window so we capybara can update the page
      job_listing_window = window_opened_by { link.click }
      sleep(3)
      # in the job listings page we opened in a new tab print the job description
      within_window job_listing_window do
        reqs = extract_requirements
        if reqs != nil
          if block_given?
            yield reqs
          else
            @job_requirements[link['href']] = matching_algorithm(reqs)
          end
        end
      end
    end
    @job_links = []
    @job_requirements unless block_given?
  end

  def extract_requirements
    if page.has_selector?("#job-content #job_summary ul li")
      page.all("#job-content #job_summary ul li").map{|x| x.text}
    elsif page.has_selector?("#job-content #job_summary")
      page.find("#job-content #job_summary").text.split('.')
    end
  end

  def filter_jobs
    @jobs = all("#resultsCol .row.result")
    # filter out sponsored jobs && accept "easily apply" jobs
    @easy_jobs = @jobs.select { |job| job.all('.sdn').length == 0 && job.all('.iaP > span.iaLabel').length > 0 }
    # get ONLY the job title link
    @easy_jobs.each do |job|
      job.all("a.turnstileLink[data-tn-element='jobTitle']").each do |x|
        @job_links << x
      end
    end
    @job_links
  end

  def close_modal
    # check if there is a modal that needs to be closed
    if page.has_selector?('#prime-popover-close-button')
      page.find('#prime-popover-close-button').click
    end
  end

  def perform_search
    # For indeed
    fill_in 'q', :with => @skillset
    fill_in 'l', :with => @region
    find('#fj').click
    sleep(1)
  end
end

JobScraper.new('http://www.indeed.com/', ARGV[0], ARGV[3]).scrape(ARGV[1], ARGV[2])

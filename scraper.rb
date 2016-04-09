url = "http://www.indeed.com/jobs?q=Ruby&l=New+York%2C+NY"

require 'capybara/dsl'
require 'capybara-webkit'
require 'cgi'
require 'timeout'
require 'capybara'
require 'csv'

class JobScraper
  include Capybara::DSL

  def initialize url
    # Capybara.default_driver = :webkit
    # Capybara.javascript_driver = :webkit
    Capybara.default_driver = :selenium
    Capybara.javascript_driver = :selenium
    Capybara::Webkit.configure do |config|
      # config.allow_url("www.ventureloop.com")
      config.allow_url("http://www.indeed.com/")
      config.block_unknown_urls
    end
    @job_links = []
    @url = url
  end

  def scrape
    visit @url
    sleep(2)
    # login
    job_information

    within("#resultsCol") do
      @jobs = all(".row.result")
      @easy_jobs = @jobs.select do |job|
        # filter out sponsored jobs && accept "easily apply" jobs
        job.all('.sdn').length == 0 && job.all('.iaP > span.iaLabel').length > 0
      end

      links_to_follow = []

      @easy_jobs.each do |job|
        # get ONLY the job title link
        job.all("a.turnstileLink[data-tn-element='jobTitle']").each do |x|
          links_to_follow << x['href']
        end
      end
      links_to_follow.each do |link|
        visit link
        sleep(2)
        p page.find(".job-content").text
        # p job_title = find(".jobtitle").text
        # p job_company = find(".company").text
        # p job_description = find("#job_summary").text
        
      end
    end
  end

  def job_page
    sleep(2)
    p find(".job-content").tag_name
  end

  def job_information
    # For indeed
    fill_in 'q', :with => 'programmer or developer or coder'
    fill_in 'l', :with => 'Miami, FL'
    find('#fj').click
    sleep(2)
  end
end


JobScraper.new('http://www.indeed.com/').scrape


  # def scrape
  #   visit @url
  #   sleep(2)
  #   # login
  #   # job_information
  #
  #   within("#resultsCol") do
  #     @jobs = all(".iaP > span.iaLabel")
  #     @easy_jobs = @jobs.select { |job| job.text.match(/Easily apply/) } # || job.text.match(/Apply with your Indeed Resume/) }
  #
  #     @easy_jobs.each do |job_label|
  #       ancestor = find_parent(job_label)
  #       p ancestor.text
  #       p has_link? ancestor[:href]   #.find("h2.jobtitle > a")
  #       ancestor.click
  #       sleep(2)
  #       # p job_div.tag_name
  #       # puts job.find(:xpath, '../..').tag_name   #.name
  #
  #       #job_link = job.find(:xpath, '..')
  #
  #       # find(:xpath, '/".row.result"/..').text   #.fill_in "Name:", :with => name
  #       # parent_of_parent = node.find(:xpath, '../..')
  #     end

      # @jobs = all(".row.sjlast.result")
      # @jobs.each do |job|
      #   sleep(1)
      #   if job.has_css?('.iaP')
      #     # p company = job.find(".company").text
      #     # p job_title = job.find(".jobtitle.turnstileLink").text
      #     # p job_description = job.find(".summary").text
      #
      #     job.find(".jobtitle.turnstileLink").click
      #     sleep(3)
      #     job_page
      #   end
      # end

  #   end
  # end

  def find_parent(job_label)
    until job_label.has_css?("a.turnstileLink") || job_label.has_css?("a.jobtitle.turnstileLink")
      job_label = job_label.find(:xpath, '..')
    end
    job_label
  end

  def job_page
    sleep(2)
    p find("#apply-state-picker-container", {visible: false})
  end

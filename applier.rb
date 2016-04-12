require 'capybara/dsl'
require 'capybara-webkit'
require 'cgi'
require 'timeout'
require 'capybara'
require 'csv'
require 'byebug'
require './matcher'

class JobApplier
  include Capybara::DSL

  def initialize url
    # Capybara.default_driver = :webkit
    # Capybara.javascript_driver = :webkit
    Capybara.default_driver = :selenium
    Capybara.javascript_driver = :selenium
    Capybara::Webkit.configure do |config|
      config.allow_url("http://www.indeed.com/")
      config.block_unknown_urls
    end
    @job_links = []
    @url = url
  end

  def scrape
    visit @url
    sleep(1)
    find('a.indeed-apply-button').click
    wait_until { page.has_selector?('.indeed-apply-popup', visible: true) }
    complete_step_1
    complete_additional_steps
  end

  def complete_step_1
    # change q% to Q& once you have your variables
    cover_letter_body = %q(
Hey!

Thanks for taking the time to review my application. I actually wrote a script to automatically apply to your job because it looks like it's a #{good|great|excellent} fit for my skills - my matching algorithm actually said there is #{percent}% chance you'd be interested in interviewing me. You can check out the match profile I created for your job posting here: #{url_for_analysis}

I'd really love the opportunity to interview at #{company_name} for the open #{job_title} position.

Thanks again. You can reach me at #{phone_number} if you'd like to chat :smile:

P.S. if you're interested in how my bot is actually handling applications for me, you can check out the source code that applied on github: #{link_to_github_for_your_script}.
    )

    # there is variation in the apply forms
    begin
      fill_in 'First Name', with: 'Juan'
      fill_in 'Last Name', with: 'Ortiz'
    rescue
      fill_in 'Name', with: 'Ortiz'
    end
    begin
      fill_in 'Phone Number (optional)', with: '123-456-7890'
    rescue
      fill_in 'Phone Number', with: '123-456-7890'
    end

    fill_in 'Email', with: 'jmopr@asdfasd.com'
    fill_in 'Cover Letter (optional)', with: cover_letter_body
    attach_file('Resume', File.absolute_path('./path to resume'))
    click 'Continue'
  end

  def complete_additional_steps
    # only complete required fields (skip optional)
    all('label').each do |field|
      unless field.text.include? 'optional'
        answer_radio_questions
        answer_text_questions
        click 'Continue'
      end
    end

    until page.has_selector?('input#apply') 
      complete_additional_steps
    end
  end

  def answer_radio_questions
    # should only be running on required questions
    # just answer yes all the time or fill in with info
    all("input[type='radio'][value='1']").each do |radio|
      choose(radio['id'])
    end
  end

  def answer_text_questions
    # should only be running on required questions
    answers = {
      'projects' => "I actually built a data explorer based on salary data for miami dade county: http://codeformiami.herokuapp.com/",
      'Website' => "data explorer for salary data for miami dade county: http://codeformiami.herokuapp.com/",
      'LinkedIn' => "https://pr.linkedin.com/in/jmopr",
      'Reference' => [
        "Auston Bunsen auston@wyncode.co 954-345-4563",
        "Rodney Perez rodney@gmail.com 305-345-4563",
        "Rodney Perez rodney@gmail.com 305-345-4563"
      ]
    }

    within('.question-page') do 
      all('textarea, input[type="text"]').each do |field|
        # first .find(:xpath, "..") gives us div.input_border
        # second .find(:xpath, "..") gives us div.input-question
        question = field.find(:xpath, "..").find(:xpath, "..").find('label')

        # see if any of the 
        answers.keys.each do |question_we_can_answer|
          if question.include? question_we_can_answer
            fill_in question, with: answers[question_we_can_answer]
          end
        end
      end
    end
  end
    # perform_search
    # close_modal
    # filter_jobs

  #   gather_requirements do |job_reqs|
  #     Job.create(
  #       title: page.first(".jobtitle").text,
  #       description: job_reqs,
  #       company: page.first(".company").text,
  #       post_date: page.first(".date").text,
  #       url: page.current_url,
  #       score: matching_algorithm(job_reqs),
  #       applied: false
  #     )
  #   end
  # end
  #
  # def gather_requirements
  #   @job_requirements = {}
  #   # visit the job listing page for a given job
  #   @job_links.each do |link|
  #     # get a handle on the new window so we capybara can update the page
  #     job_listing_window = window_opened_by { link.click }
  #     sleep(1)
  #     # in the job listings page we opened in a new tab print the job description
  #     within_window job_listing_window do
  #       reqs = extract_requirements
  #
  #       if block_given?
  #         yield reqs
  #       else
  #         @job_requirements[link['href']] = matching_algorithm(reqs)
  #       end
  #     end
  #   end
  #   @job_requirements unless block_given?
  # end
  #
  # def extract_requirements
  #   if page.has_selector?("#job-content #job_summary ul li")
  #     page.all("#job-content #job_summary ul li").map{|x| x.text}
  #   else
  #     page.find("#job-content #job_summary").text.split('.')
  #   end
  # end
  #
  # def filter_jobs
  #   @jobs = all("#resultsCol .row.result")
  #
  #   # filter out sponsored jobs && accept "easily apply" jobs
  #   @easy_jobs = @jobs.select { |job| job.all('.sdn').length == 0 && job.all('.iaP > span.iaLabel').length > 0 }
  #   # get ONLY the job title link
  #   @easy_jobs.each do |job|
  #     job.all("a.turnstileLink[data-tn-element='jobTitle']").each do |x|
  #       @job_links << x
  #     end
  #   end
  #
  #   @job_links
  # end
  #
  # def close_modal
  #   # check if there is a modal that needs to be closed
  #   if page.has_selector?('#prime-popover-close-button')
  #     page.find('#prime-popover-close-button').click
  #   end
  # end
  #
  # def perform_search
  #   # For indeed
  #   fill_in 'q', :with => @skillset
  #   fill_in 'l', :with => @region
  #   find('#fj').click
  #   sleep(1)
  # end
end

JobApplier.new(ARGV.first)

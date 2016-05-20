require 'capybara/dsl'
require 'capybara-webkit'
require 'cgi'
require 'timeout'
require 'capybara'

class JobApplier
  include Capybara::DSL

  def initialize(userID, jobID)
    # Capybara.default_driver = :webkit
    # Capybara.javascript_driver = :webkit
    Capybara.default_driver = :selenium
    Capybara.javascript_driver = :selenium
    Capybara::Webkit.configure do |config|
      config.allow_url("http://www.indeed.com/")
      config.block_unknown_urls
    end
    @job = Job.find(jobID)
    @user = User.find(userID)
  end

  def scrape
    unless @job.applied
      visit @job.url
      unless page.has_css?('p.expired')
        page.find('a.indeed-apply-button', match: :first).click

        page.driver.within_frame(1) do
          page.driver.within_frame(0) do
            complete_step_one
            complete_additional_steps
          end
        end
      end
      Job.delete(@job.id)
      page.close
    end
  end

  def complete_step_one
    company_name = @job.company
    job_title = @job.title
    phone_number = @user.phone_number
    link_to_github = "https://github.com/jmopr/job-hunter/blob/master/matcher.rb"
    percent = @job.score.round(2)
    url_for_analysis = "http://job-diana.herokuapp.com/users/jobs/#{@job.hex_id}"
    fit = category @job.score
    cover_letter_body = %Q(
Dear Hiring Manager,

Hello, my name is Juan Ortiz. Nice to meet you!

I actually wrote a bot to automatically apply to your job because it looks like it's a #{fit} fit for my skills - my matching algorithm actually said there is #{percent}% chance you'd be interested in interviewing me.

You can check out the match profile I created for your job posting here: #{url_for_analysis} I'd really love the opportunity to interview at  #{company_name} for the open #{job_title} position.

Thanks again. You can reach me at #{phone_number} if you'd like to chat.

P.S. if you're interested in how my bot is actually handling applications for me, you can check out the source code that applied on github: #{link_to_github}.
)
    # there is variation in the apply forms
    begin
      fill_in 'applicant.firstName', with: @user.first_name
      fill_in 'applicant.lastName', with: @user.last_name
    rescue
      fill_in 'applicant.name', with: "#{@user.first_name} #{@user.last_name}"
    end

    fill_in 'applicant.phoneNumber', with: @user.phone_number
    fill_in 'applicant.email', with: @user.email
    fill_in 'applicant.applicationMessage', with: cover_letter_body
    attach_file('resume', File.absolute_path("./public#{@user.document.url}"))
    if page.has_selector?('a.button_content.form-page-next')
      page.find('a.button_content.form-page-next', match: :first).click
    else
      apply
    end
  end

  def complete_additional_steps
    # only complete required fields (skip optional)
    all('label').each do |field|
      if !field.text.include? 'optional'
        answer_radio_questions
        answer_text_questions
        if page.has_selector?('a.button_content.form-page-next')
          page.find('a.button_content.form-page-next', match: :first).click
          sleep(1)
        end
      elsif page.has_selector?('a.button_content.form-page-next')
        page.find('a.button_content.form-page-next', match: :first).click
        sleep(1)
        complete_additional_steps
      end
    end
    until page.has_selector?('input#apply')
      complete_additional_steps
    end
    apply
  end

  def answer_radio_questions
    if page.has_selector?("input[type='radio'][value='0']")
      all("input[type='radio'][value='0']").each do |radio|
        radio.click
      end
    else
      all("input[type='radio'][value='Yes']").each do |radio|
        radio.click
      end
    end
  end

  def answer_text_questions
    # should only be running on required questions
    answers = {
      'projects' => "I actually built a data explorer based on salary data for miami dade county: http://codeformiami.herokuapp.com/",
      'Website' => "Data explorer for salary data for miami dade county: http://codeformiami.herokuapp.com/",
      'LinkedIn' => @user.linkedin,
      'How did you hear about this job?' => 'indeed.com',
      'Reference' => [
        "Auston Bunsen auston@wyncode.co 954-670-3289",
        "Rodney Perez rodney@gmail.com 305-345-4563"
      ],
      'salary expectations' => '$50,000',
      'How did you hear about this job?' => 'indeed.com',
      'Github' => "https://github.com/#{@user.github}",
      'In 150 characters or fewer, tell us what makes you unique. Try to be creative and say something that will catch our eye!' => "I am a driven individual that will not stop until I find a solution to any type of problem.",
      'What are your salary requirements (excluding bonus, commission, equity)?' => 'Entry-Level',
      'Address Line' => '3011 Marta Circle Apt. 102',
      'City' => 'Kissimmee',
      'State' => 'Florida'
    }

    within('.question-page') do
      all('textarea, input[type="text"]').each do |field|
        question = field.find(:xpath, "..").find(:xpath, "..").find('label')
        # see if any of the question is 'answerable' with answers.
        answers.keys.each do |question_we_can_answer|
          if question.text.include? question_we_can_answer
            fill_in field['name'], with: answers[question_we_can_answer]
          end
        end
      end
    end
  end

  def category percentage
    if percentage > 85
      'excellent'
    elsif percentage > 65 && percentage <= 85
      'great'
    else
      'good'
    end
  end

  def apply
    # Apply button is in the page.
    check = page.find('#apply', match: :first).click
    if check == 'ok'
      @job.update(applied: true)
      page.close
    end
  end
end

JobApplier.new(ARGV[0], ARGV[1]).scrape

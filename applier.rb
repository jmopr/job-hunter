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
    visit @job.url
    sleep(1)
    page.find('a.indeed-apply-button', match: :first).click
    sleep(1)

    page.driver.within_frame(1) do
      page.driver.within_frame(0) do
        complete_step_one
        complete_additional_steps
      end
    end
  end

  def complete_step_one
    company_name = @job.company
    job_title = @job.title
    phone_number = @user.phone_number
    link_to_github = "https://github.com/jmopr/job-hunter/blob/master/matcher.rb"
    percent = @job.score.round(2)
    url_for_analysis = @job.url
    fit = category @job.score
    cover_letter_body = %Q(
    Hey!
    Thanks for taking the time to review my application. I actually wrote a script to automatically apply to your job because it looks like it's a #{fit} fit for my skills - my matching algorithm actually said there is #{percent}% chance you'd be interested in interviewing me. You can check out the match profile I created for your job posting here: #{url_for_analysis}
    I'd really love the opportunity to interview at #{company_name} for the open #{job_title} position.
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
    # attach_file('resume', File.absolute_path('./public/system/users/documents/000/000/001/original/Resume.pdf'))
    attach_file('resume', File.absolute_path("./public#{@user.document.url}"))
    sleep(5)
    page.find('a.button_content.form-page-next', match: :first).click
  end

  def complete_additional_steps
    # only complete required fields (skip optional)
    all('label').each do |field|
      unless field.text.include? 'optional'
        answer_radio_questions
        answer_text_questions
        click 'Continue'
        sleep(1)
      end
    end

    until page.has_selector?('input#apply')
      complete_additional_steps
    end
    check = page.find('.button_content', match: :first).click

    if check == 'ok'
      @job.update(applied: true)
    end
    sleep(2)
  end

  def answer_radio_questions
    # should only be running on required questions
    # just answer yes all the time or fill in with info
    all("input[type='radio'][value='0']").each do |radio|
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

  def category percentage
    if percentage > 90
      'excellent'
    elsif percentage > 70 && percentage < 89
      'great'
    else
      'good'
    end
  end
end

JobApplier.new(ARGV[0], ARGV[1]).scrape

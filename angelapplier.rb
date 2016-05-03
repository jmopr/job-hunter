require 'capybara/dsl'
require 'capybara-webkit'
require 'cgi'
require 'timeout'
require 'capybara'
require 'dotenv'
Dotenv.load

class JobApplier
  include Capybara::DSL

  def initialize(userID, jobID)
    # Capybara.default_driver = :webkit
    # Capybara.javascript_driver = :webkit
    Capybara.default_driver = :selenium
    Capybara.javascript_driver = :selenium
    Capybara::Webkit.configure do |config|
      config.allow_url("http://www.angel.co")
      config.block_unknown_urls
    end
    @job = Job.find(jobID)
    @user = User.find(userID)
    @url = "http://www.angel.co"
  end

  def scrape
    unless @job.applied
      visit @url
      page.find('.home_ctas.home_talent_jobs_button.g-button.larger.blue', match: :first).click
      # log in
      login
      visit @job.url
      if page.has_css?('.fontello-ok')
        @job.update(applied: true)
      else
        page.find('.c-button.c-button--blue.js-interested-button', match: :first).click
        add_note
        apply
      end
    end
  end

  def login
    # using angel account
    log_link = page.find_link('Log in').click
    fill_in 'user[email]', :with => @user.email
    fill_in 'user[password]', :with => ENV['ANGEL_KEY']
    page.find("input[name='commit']").click

    # using linked in uncomment below and comment above.
    # link = page.find('.c-button.c-button--gray.linkedin.network_button.option.s-vgBottom2.u-colorGray4.u-fontWeight400', match: :first)
    # linked_window = window_opened_by { link.click }
    # within_window linked_window do
    #   fill_in 'session_key', :with => "jmopr83@hotmail.com"
    #   fill_in 'session_password', :with => "Braves5157"
    #   find('.allow').click
    # end
  end

  def add_note
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

    text_area = first(:css, 'textarea.autogrow.user-note-textarea.u-block').native
    text_area.send_keys(cover_letter_body)
    sleep(1)
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
    check = page.find('.apply-button.c-button.c-button--blue.s-vgTop1.u-block.js-apply-button', match: :first).click
    if check == 'ok'
      @job.update(applied: true)
    end
  end
end

JobApplier.new(ARGV[0], ARGV[1]).scrape

class JobsController < ApplicationController
  before_action :require_logged_in, only: [:new, :index, :match, :destroy]

  def new
    @job = Job.new
  end

  def search
    params['angel_scraper'] == 'yes' ? applier = 'angelscraper' : applier = 'scraper'
    @jobs = Job.get_jobs(applier, current_user, params[:title], params[:location], params[:pages])
    redirect_to users_jobs_path
  end

  def match
    @user = current_user
    @jobs = Job.match.order(:id).page params[:page]
  end

  def apply
    @user = current_user
    params['angel_applier'] == 'on' ? applier = 'angelapplier' : applier = 'applier'
    Job.apply(@user, Job.match, applier)
    redirect_to users_match_path
  end

  def show
    @job = Job.find_by(hex_id: params[:id])
    @user = current_user || User.find(@job.user_id)
  end

  def index
    @user = current_user
    @jobs = Job.order(:id).page params[:page]
  end

  def create
    @job = Job.new(job_params)
    @job.save
  end

  def destroy
    Job.delete_all
    Job.reset_pk_sequence
    redirect_to users_jobs_path
  end

  def destroy_multiple
    Job.destroy(params[:jobs]) unless params[:jobs].nil?
    redirect_to users_match_path
  end

  private
    def job_params
      params.require(:job).permit(:title, :company, :description)
    end
end

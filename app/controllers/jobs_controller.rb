class JobsController < ApplicationController
  before_action :require_logged_in, only: [:new, :index, :match, :destroy]

  def new
    @job = Job.new
  end

  def search
    params['indeed_scraper'] == '1' ? applier = 'scraper' : applier = 'angelscraper'
    @jobs = Job.get_jobs(applier, current_user, params[:title], params[:location], params[:pages])
    redirect_to users_jobs_path
  end

  def match
    @user = current_user
    @jobs = Job.match.order(:id).page params[:page]
  end

  def apply
    @user = current_user
    params['indeed_applier'] == 'on' ? applier = 'applier' : applier = 'angelapplier'
    Job.apply(@user, Job.match, applier)
    redirect_to users_match_path
  end

  def show
    @job = Job.find_by(hex_id: params[:id])
    @user = current_user || User.find(@job.user_id)
    #   render json: Job.find(params[:id]), status: :ok
    # rescue
    #   render json: {job: {errors: "job not found"}}, status: :not_found
  end

  def index
    @user = current_user
    @jobs = Job.order(:id).page params[:page]
    # render json: Job.list(job_params), status: :ok
  end

  def create
    @job = Job.new(job_params)
    @job.save
    # if job.save
    #   render json: job, status: :created, location: job
    # else
    #   render json: job.errors, status: :unprocessable_entity
    # end
  end

  def destroy
    Job.delete_all
    Job.reset_pk_sequence
    redirect_to users_jobs_path
  #   render json: Job.all
  # rescue
  #   render json: {job: {errors: "job not found"}}, status: :not_found
  end

  private
    def job_params
      params.require(:job).permit(:title, :company, :description)
    end
end

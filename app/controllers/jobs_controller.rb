class JobsController < ApplicationController
  before_action :require_logged_in, only: [:index, :match, :destroy]

  def new
    @job = Job.new
  end

  def search
    @user = current_user
    @jobs = Job.get_jobs(@user, params[:title], params[:location], params[:pages])
    redirect_to users_jobs_path
  end

  def match
    @user = current_user
    @jobs = Job.match
  end

  def apply
    @user = current_user
    Job.apply(@user, Job.match)
    redirect_to users_match_path
  end

  def show
    @user = current_user
    @job = Job.find(params[:id])
    @jobs = Job.applied
    #   render json: Job.find(params[:id]), status: :ok
    # rescue
    #   render json: {job: {errors: "job not found"}}, status: :not_found
  end

  def index
    @user = current_user
    @jobs = Job.all
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
    params.require(:job).permit(:title, :description)
  end
end

class JobsControllerController < ApplicationController
  def show
    render json: Job.find(params[:id]), status: :ok
    rescue
      render json: {job: {errors: "job not found"}}, status: :not_found
  end

  def index
    render json: Job.list(job_params), status: :ok
  end

  def create
    job = Job.new(job_params)

    if job.save
      render json: job, status: :created, location: job
    else
      render json: job.errors, status: :unprocessable_entity
    end
  end

  def destroy
    job.destroy(params[:id])
    render json: Job.all
    rescue
      render json: {job: {errors: "job not found"}}, status: :not_found
  end

  private
    def job_params
      # params.require(:appointment).permit(:appt_day, :start_time, :end_time, :first_name, :last_name, :comments)
      params.require(:job).permit(:title, :post_date, :description)
    end
end

# require 'capybara/rails'
class JobsController < ApplicationController
  # before_action :set_note, only: [:show, :edit, :update, :destroy]
  # before_action :require_logged_in

  def new
    @user = current_user
  end

  def match
    @jobs = Job.match
    Job.apply(@jobs)
  end

  def show

  #   render json: Job.find(params[:id]), status: :ok
  # rescue
  #   render json: {job: {errors: "job not found"}}, status: :not_found
  end

  def index
    Job.get_jobs
    @job = Job.all
    # render json: Job.list(job_params), status: :ok
  end

  def create
    # job = Job.new(job_params)
    #
    # if job.save
    #
    #   render json: job, status: :created, location: job
    # else
    #   render json: job.errors, status: :unprocessable_entity
    # end
  end

  def destroy
    job.destroy(params[:id])
    render_to search_path
  #
  #   render json: Job.all
  # rescue
  #   render json: {job: {errors: "job not found"}}, status: :not_found
  end

  private
  def job_params
    params.require(:job).permit(:title, :description)
  end

  # # Use callbacks to share common setup or constraints between actions.
  # def set_note
  #  @note = current_user.notes.find(params[:id])
  # end
  # GET /notes

  # GET /notes.json

  # def index
  #
  # @notes = current_user.notes.all
  #
  # end
  #
  # # GET /notes/1
  #
  # # GET /notes/1.json
  #
  # def show
  #
  # end
  #
  # # GET /notes/new
  #
  # def new
  #
  # @note = current_user.notes.new
  #
  # end
  #
  # # GET /notes/1/edit
  #
  # def edit end
  #
  # # POST /notes
  #
  # # POST /notes.json def create
  #
  # @note = current_user.notes.new(note_params)
  #
  # respond_to do |format| if @note.save


  # DELETE /notes/1

  # DELETE /notes/1.json
  #
  #  def destroy @note.destroy
  #
  #  respond_to do |format|
  #
  #  format.html { redirect_to notes_url, notice: 'Note was successfully
  #
  # destroyed.' }
  #
  #  format.json { head :no_content } end

end

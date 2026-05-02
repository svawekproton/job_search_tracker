class JobApplicationsController < ApplicationController
  before_action :set_job_application, only: %i[ show edit update destroy ]

  # GET /job_applications or /job_applications.json
  def index
    @job_applications = JobApplication.all
    @job_applications = @job_applications.search(params[:query]) if params[:query].present?
    @job_applications = @job_applications.where(status: params[:status]) if params[:status].present?
    @job_applications = @job_applications.order(applied_at: :desc)
  end

  # GET /job_applications/1 or /job_applications/1.json
  def show
  end

  # GET /job_applications/new
  def new
    @job_application = JobApplication.new
  end

  # GET /job_applications/1/edit
  def edit
  end

  # POST /job_applications or /job_applications.json
  def create
    @job_application = JobApplication.new(job_application_params)

    respond_to do |format|
      if @job_application.save
        format.html { redirect_to @job_application, notice: "Job application was successfully created." }
        format.json { render :show, status: :created, location: @job_application }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_applications/1 or /job_applications/1.json
  def update
    respond_to do |format|
      if @job_application.update(job_application_params)
        format.html { redirect_to @job_application, notice: "Job application was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @job_application }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_applications/1 or /job_applications/1.json
  def destroy
    @job_application.destroy!

    respond_to do |format|
      format.html { redirect_to job_applications_path, notice: "Job application was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_application
      @job_application = JobApplication.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def job_application_params
      params.expect(job_application: [ :company_name, :position, :status, :applied_at, :url, :location, :description, :cv, :cover_letter ])
    end
end

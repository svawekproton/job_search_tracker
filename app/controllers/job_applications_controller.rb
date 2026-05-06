class JobApplicationsController < ApplicationController
  before_action :set_job_application, only: %i[ show edit update destroy ]

  # GET /job_applications
  def index
    @job_applications = Current.user.job_applications
    @job_applications = @job_applications.search(params[:query]) if params[:query].present?
    @job_applications = @job_applications.where(status: params[:status]) if params[:status].present?
    @job_applications = @job_applications.order(applied_at: :desc)
  end

  # GET /job_applications/1
  def show
  end

  # GET /job_applications/new
  def new
    @job_application = Current.user.job_applications.new
  end

  # GET /job_applications/1/edit
  def edit
  end

  # POST /job_applications
  def create
    @job_application = Current.user.job_applications.build(job_application_params)

    if @job_application.save
      redirect_to @job_application, notice: "Job application was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /job_applications/1
  def update
    if @job_application.update(job_application_params)
      redirect_to @job_application, notice: "Job application was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /job_applications/1
  def destroy
    @job_application.destroy!
    redirect_to job_applications_path, notice: "Job application was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_application
      @job_application = Current.user.job_applications.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def job_application_params
      params.expect(job_application: [ :company_name, :position, :status, :applied_at, :url, :location, :description, :cv, :cover_letter ])
    end
end

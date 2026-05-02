class NotesController < ApplicationController
  before_action :set_job_application

  def create
    @note = @job_application.notes.build(note_params)

    respond_to do |format|
      if @note.save
        format.turbo_stream
        format.html { redirect_to @job_application, notice: "Note was successfully created." }
      else
        format.html { redirect_to @job_application, alert: "Error creating note." }
      end
    end
  end

  private

  def set_job_application
    @job_application = JobApplication.find(params[:job_application_id])
  end

  def note_params
    params.require(:note).permit(:category, :content)
  end
end

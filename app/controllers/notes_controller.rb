class NotesController < ApplicationController
  before_action :set_job_application

  def create
    @note = @job_application.notes.build(note_params)

    respond_to do |format|
      if @note.save
        format.turbo_stream
        format.html { redirect_to @job_application, notice: "Note was successfully created." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_note",
            partial: "notes/form",
            locals: { job_application: @job_application, note: @note }
          ), status: :unprocessable_entity
        end
        format.html { redirect_to @job_application, alert: "Error creating note." }
      end
    end
  end

  private

  def set_job_application
    @job_application = Current.user.job_applications.find(params.expect(:job_application_id))
  end

  def note_params
    params.expect(note: [ :category, :content ])
  end
end

class EventsController < ApplicationController
  before_action :set_job_application

  def create
    @event = @job_application.events.build(event_params)

    respond_to do |format|
      if @event.save
        format.turbo_stream
        format.html { redirect_to @job_application, notice: "Event was successfully created." }
      else
        format.html { redirect_to @job_application, alert: "Error creating event." }
      end
    end
  end

  private

  def set_job_application
    @job_application = Current.user.job_applications.find(params[:job_application_id])
  end

  def event_params
    params.require(:event).permit(:title, :event_type, :scheduled_at, :notes)
  end
end

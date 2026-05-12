class EventsController < ApplicationController
  before_action :set_job_application

  def create
    @event = @job_application.events.build(event_params)

    respond_to do |format|
      if @event.save
        format.turbo_stream
        format.html { redirect_to @job_application, notice: "Event was successfully created." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_event",
            partial: "events/form",
            locals: { job_application: @job_application, event: @event }
          ), status: :unprocessable_entity
        end
        format.html { redirect_to @job_application, alert: "Error creating event." }
      end
    end
  end

  private

  def set_job_application
    @job_application = Current.user.job_applications.find(params.expect(:job_application_id))
  end

  def event_params
    params.expect(event: [ :title, :event_type, :scheduled_at, :notes ])
  end
end

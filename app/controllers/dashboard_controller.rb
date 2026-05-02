class DashboardController < ApplicationController
  def index
    @total_applications = JobApplication.count
    @active_interviews = JobApplication.interviewing.count
    @offers = JobApplication.offered.count
    @recent_events = Event.where("scheduled_at >= ?", Time.current).order(scheduled_at: :asc).limit(5)
  end
end

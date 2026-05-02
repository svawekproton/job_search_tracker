class DashboardController < ApplicationController
  def index
    @total_applications = JobApplication.count
    @active_interviews = JobApplication.interviewing.count
    @offers = JobApplication.offered.count
    @success_rate = @total_applications > 0 ? ((@offers.to_f / @total_applications) * 100).round(1) : nil
    
    @upcoming_events = Event.where("scheduled_at >= ?", Time.current).order(scheduled_at: :asc).limit(10)
    @recent_activity = JobApplication.order(updated_at: :desc).limit(5)
  end
end

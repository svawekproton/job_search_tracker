class DashboardController < ApplicationController
  def index
    @total_applications = Current.user.job_applications.count
    @active_interviews = Current.user.job_applications.interviewing.count
    @offers = Current.user.job_applications.offered.count
    @success_rate = @total_applications > 0 ? ((@offers.to_f / @total_applications) * 100).round(1) : nil
    
    @upcoming_events = Current.user.events.where("scheduled_at >= ?", Time.current).order(scheduled_at: :asc).limit(10)
    @recent_activity = Current.user.job_applications.order(updated_at: :desc).limit(5)
  end
end

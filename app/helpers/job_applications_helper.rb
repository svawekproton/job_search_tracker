module JobApplicationsHelper
  def status_badge_color(status)
    case status.to_sym
    when :applied
      "info"
    when :interviewing
      "primary"
    when :offered
      "success"
    when :rejected
      "danger"
    when :withdrawn
      "secondary"
    else
      "light"
    end
  end
end

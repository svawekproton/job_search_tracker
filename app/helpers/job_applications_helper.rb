module JobApplicationsHelper
  def status_badge_classes(status)
    case status.to_sym
    when :applied
      "bg-applied text-applied-text"
    when :interviewing
      "bg-interviewing text-interviewing-text"
    when :offered
      "bg-offered text-offered-text"
    when :rejected
      "bg-rejected text-rejected-text"
    when :withdrawn
      "bg-withdrawn text-withdrawn-text"
    else
      "bg-light text-dark"
    end
  end

  def status_border_color(status)
    case status.to_sym
    when :applied then "var(--status-applied-bg)"
    when :interviewing then "var(--status-interviewing-bg)"
    when :offered then "var(--status-offered-bg)"
    when :rejected then "var(--status-rejected-bg)"
    when :withdrawn then "var(--status-withdrawn-bg)"
    else "#DEE2E6"
    end
  end
end

class Event < ApplicationRecord
  belongs_to :job_application

  enum :event_type, {
    call: 0,
    technical_interview: 1,
    hr_interview: 2,
    follow_up: 3
  }

  validates :title, :event_type, :scheduled_at, presence: true
end

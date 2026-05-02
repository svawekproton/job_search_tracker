require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:job_application) { 
    JobApplication.create!(
      company_name: "Google", 
      position: "Software Engineer"
    ) 
  }

  it "is valid with valid attributes" do
    event = job_application.events.build(
      title: "Phone Screen",
      event_type: :call,
      scheduled_at: Time.current
    )
    expect(event).to be_valid
  end

  it "is invalid without a title" do
    event = job_application.events.build(title: nil)
    expect(event).not_to be_valid
  end

  it "is invalid without a scheduled_at" do
    event = job_application.events.build(scheduled_at: nil)
    expect(event).not_to be_valid
  end
end

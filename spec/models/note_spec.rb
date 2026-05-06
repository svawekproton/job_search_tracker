require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { User.create!(email_address: "test@example.com", password: "password", password_confirmation: "password") }
  let(:job_application) { 
    user.job_applications.create!(
      company_name: "Google", 
      position: "Software Engineer",
      applied_at: Date.today
    ) 
  }

  it "is valid with content" do
    note = job_application.notes.build(content: "Test note content")
    expect(note).to be_valid
  end

  it "is invalid without content" do
    note = job_application.notes.build(content: nil)
    expect(note).not_to be_valid
  end
end

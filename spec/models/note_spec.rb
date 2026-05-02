require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:job_application) { 
    JobApplication.create!(
      company_name: "Google", 
      position: "Software Engineer"
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

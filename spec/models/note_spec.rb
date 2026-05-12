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
    note = job_application.notes.build(category: "General", content: "Test note content")
    expect(note).to be_valid
  end

  it "is invalid without content" do
    note = job_application.notes.build(category: "General", content: nil)
    expect(note).not_to be_valid
  end

  it "is invalid with an unknown category" do
    note = job_application.notes.build(category: "Other", content: "Test note content")

    expect(note).not_to be_valid
    expect(note.errors[:category]).to be_present
  end

  describe ".category_options" do
    it "returns select options from the category source of truth" do
      expect(described_class.category_options).to eq([
        [ "Question", "Question" ],
        [ "Answer", "Answer" ],
        [ "General", "General" ]
      ])
    end
  end

  describe ".interview_prep" do
    it "returns question and answer notes" do
      question = job_application.notes.create!(category: "Question", content: "Question")
      answer = job_application.notes.create!(category: "Answer", content: "Answer")
      job_application.notes.create!(category: "General", content: "General")

      expect(described_class.interview_prep).to contain_exactly(question, answer)
    end
  end

  describe "#interview_prep_category?" do
    it "identifies interview prep categories" do
      question = job_application.notes.build(category: "Question", content: "Question")
      general = job_application.notes.build(category: "General", content: "General")

      expect(question).to be_interview_prep_category
      expect(general).not_to be_interview_prep_category
    end
  end
end

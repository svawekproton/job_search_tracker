require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  let(:user) { User.create!(email_address: "test@example.com", password: "password", password_confirmation: "password") }

  it "is valid with valid attributes" do
    job_application = user.job_applications.new(
      company_name: "Google",
      position: "Software Engineer",
      status: :applied,
      applied_at: Date.today
    )
    expect(job_application).to be_valid
  end

  it "is invalid without an applied_at date" do
    job_application = user.job_applications.new(applied_at: nil)
    expect(job_application).not_to be_valid
  end

  it "is invalid without a company_name" do
    job_application = user.job_applications.new(company_name: nil)
    expect(job_application).not_to be_valid
  end

  it "is invalid without a position" do
    job_application = user.job_applications.new(position: nil)
    expect(job_application).not_to be_valid
  end

  it "is invalid without a user" do
    job_application = JobApplication.new(
      company_name: "Google",
      position: "Software Engineer",
      status: :applied,
      applied_at: Date.today
    )
    expect(job_application).not_to be_valid
  end

  it "defaults to applied status" do
    job_application = JobApplication.new
    expect(job_application.status).to eq("applied")
  end

  it "allows HTTP and HTTPS listing URLs" do
    http_application = user.job_applications.new(valid_attributes.merge(url: "http://example.com/jobs/rails"))
    https_application = user.job_applications.new(valid_attributes.merge(url: "https://example.com/jobs/rails"))

    expect(http_application).to be_valid
    expect(https_application).to be_valid
  end

  it "rejects listing URLs with unsafe schemes" do
    job_application = user.job_applications.new(valid_attributes.merge(url: "javascript:alert(1)"))

    expect(job_application).not_to be_valid
    expect(job_application.errors[:url]).to include("must be an HTTP or HTTPS URL")
  end

  it "rejects malformed listing URLs" do
    job_application = user.job_applications.new(valid_attributes.merge(url: "https://"))

    expect(job_application).not_to be_valid
    expect(job_application.errors[:url]).to include("must be an HTTP or HTTPS URL")
  end

  def valid_attributes
    {
      company_name: "Google",
      position: "Software Engineer",
      status: :applied,
      applied_at: Date.today
    }
  end
end

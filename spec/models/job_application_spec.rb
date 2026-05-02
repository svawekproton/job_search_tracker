require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  it "is valid with valid attributes" do
    job_application = JobApplication.new(
      company_name: "Google",
      position: "Software Engineer",
      status: :applied
    )
    expect(job_application).to be_valid
  end

  it "is invalid without a company_name" do
    job_application = JobApplication.new(company_name: nil)
    expect(job_application).not_to be_valid
  end

  it "is invalid without a position" do
    job_application = JobApplication.new(position: nil)
    expect(job_application).not_to be_valid
  end

  it "defaults to applied status" do
    job_application = JobApplication.new
    expect(job_application.status).to eq("applied")
  end
end

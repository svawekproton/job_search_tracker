require 'rails_helper'

RSpec.describe "JobApplications", type: :request do
  describe "GET /job_applications" do
    it "returns a successful response" do
      get job_applications_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /job_applications" do
    let(:valid_attributes) {
      { company_name: "Apple", position: "Developer", status: "applied", applied_at: Date.today }
    }

    it "creates a new JobApplication" do
      expect {
        post job_applications_path, params: { job_application: valid_attributes }
      }.to change(JobApplication, :count).by(1)
    end

    it "redirects to the created job_application" do
      post job_applications_path, params: { job_application: valid_attributes }
      expect(response).to redirect_to(JobApplication.last)
    end
  end

  describe "GET /job_applications with search and filtering" do
    let!(:google) { JobApplication.create!(company_name: "Google", position: "Engineer", status: "applied", applied_at: Date.today) }
    let!(:apple) { JobApplication.create!(company_name: "Apple", position: "Designer", status: "interviewing", applied_at: Date.today) }

    it "filters by query" do
      get job_applications_path, params: { query: "Google" }
      expect(response.body).to include("Google")
      expect(response.body).not_to include("Apple")
    end

    it "filters by status" do
      get job_applications_path, params: { status: "interviewing" }
      expect(response.body).to include("Apple")
      expect(response.body).not_to include("Google")
    end
  end
end

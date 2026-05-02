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
      { company_name: "Apple", position: "Developer", status: "applied" }
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
end

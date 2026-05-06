require 'rails_helper'

RSpec.describe "JobApplications", type: :request do
  let(:user) { User.create!(email_address: "user@example.com", password: "password", password_confirmation: "password") }
  let(:other_user) { User.create!(email_address: "other@example.com", password: "password", password_confirmation: "password") }
  let!(:user_application) { user.job_applications.create!(company_name: "Apple", position: "Developer", status: "applied", applied_at: Date.today) }
  let!(:other_application) { other_user.job_applications.create!(company_name: "Google", position: "Engineer", status: "applied", applied_at: Date.today) }

  before do
    sign_in_as(user)
  end

  describe "GET /job_applications" do
    it "returns a successful response and shows own applications" do
      get job_applications_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Apple")
    end

    it "does not show other user's applications" do
      get job_applications_path
      expect(response.body).not_to include("Google")
    end

    it "does not find other user's applications via search" do
      get job_applications_path, params: { query: "Google" }
      # Verify that Google is not in the list of applications
      expect(response.body).not_to include('<h5 class="card-title fw-bold mb-1">Google</h5>')
      # Verify empty state
      expect(response.body).to include("No applications found")
    end
  end

  describe "GET /job_applications/:id" do
    it "renders a successful response for own application" do
      get job_application_path(user_application)
      expect(response).to be_successful
    end

    it "returns not found for other user's application" do
      get job_application_path(other_application)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /job_applications/:id" do
    it "updates own application" do
      patch job_application_path(user_application), params: { job_application: { company_name: "Apple Updated" } }
      expect(user_application.reload.company_name).to eq("Apple Updated")
    end

    it "returns not found for other user's application" do
      patch job_application_path(other_application), params: { job_application: { company_name: "Hacker Corp" } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /job_applications/:id" do
    it "destroys own application" do
      expect {
        delete job_application_path(user_application)
      }.to change(JobApplication, :count).by(-1)
    end

    it "returns not found for other user's application" do
      delete job_application_path(other_application)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "Nested resources (Notes & Events)" do
    it "prevents creating a note for another user's application" do
      post job_application_notes_path(other_application), params: { note: { content: "Sneaky note" } }
      expect(response).to have_http_status(:not_found)
    end

    it "prevents creating an event for another user's application" do
      post job_application_events_path(other_application), params: { event: { title: "Sneaky event", event_type: "call", scheduled_at: Time.current } }
      expect(response).to have_http_status(:not_found)
    end
  end
end

require "rails_helper"

RSpec.describe "Notes", type: :request do
  let(:user) { User.create!(email_address: "notes@example.com", password: "password", password_confirmation: "password") }
  let(:other_user) { User.create!(email_address: "other-notes@example.com", password: "password", password_confirmation: "password") }
  let(:job_application) do
    user.job_applications.create!(
      company_name: "Acme",
      position: "Engineer",
      status: :applied,
      applied_at: Date.current
    )
  end
  let(:other_application) do
    other_user.job_applications.create!(
      company_name: "Other Co",
      position: "Analyst",
      status: :applied,
      applied_at: Date.current
    )
  end

  before do
    sign_in_as(user)
  end

  describe "POST /job_applications/:job_application_id/notes" do
    let(:valid_params) { { note: { category: "Question", content: "What is the team size?" } } }

    it "creates a note and redirects on html success" do
      expect {
        post job_application_notes_path(job_application), params: valid_params
      }.to change(Note, :count).by(1)

      expect(response).to redirect_to(job_application_path(job_application))
      expect(flash[:notice]).to eq("Note was successfully created.")
    end

    it "renders a turbo-stream response on success" do
      post job_application_notes_path(job_application), params: valid_params,
        headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("turbo-stream")
    end

    it "does not create a note and redirects with alert on html failure" do
      expect {
        post job_application_notes_path(job_application), params: { note: { category: "General", content: nil } }
      }.not_to change(Note, :count)

      expect(response).to redirect_to(job_application_path(job_application))
      expect(flash[:alert]).to eq("Error creating note.")
    end

    it "returns not found for another user's job application" do
      post job_application_notes_path(other_application), params: valid_params

      expect(response).to have_http_status(:not_found)
    end
  end
end

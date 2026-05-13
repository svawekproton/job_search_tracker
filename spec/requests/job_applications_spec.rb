require "rails_helper"

RSpec.describe "JobApplications", type: :request do
  let(:user) { User.create!(email_address: "user@example.com", password: "password", password_confirmation: "password") }
  let(:other_user) { User.create!(email_address: "other@example.com", password: "password", password_confirmation: "password") }
  let!(:user_application) { user.job_applications.create!(company_name: "Apple", position: "Developer", status: "applied", applied_at: Date.today) }
  let!(:other_application) { other_user.job_applications.create!(company_name: "Google", position: "Engineer", status: "applied", applied_at: Date.today) }

  describe "GET /job_applications" do
    before { sign_in_as(user) }

    it "returns a successful response and shows own applications" do
      get job_applications_path
      expect(response).to have_http_status(:success)
      expect(rendered_application_names).to include("Apple")
    end

    it "does not show other user's applications" do
      get job_applications_path
      expect(rendered_application_names).not_to include("Google")
    end

    it "does not find other user's applications via search" do
      get job_applications_path, params: { query: "Google" }
      expect(rendered_application_names).not_to include("Google")
      expect(response.body).to include("No applications found")
    end

    it "filters applications by status" do
      user.job_applications.create!(company_name: "Stripe", position: "Developer", status: "interviewing", applied_at: Date.current)

      get job_applications_path, params: { status: "interviewing" }

      expect(rendered_application_names).to include("Stripe")
      expect(rendered_application_names).not_to include("Apple")
      expect(rendered_application_names).not_to include("Google")
    end
  end

  describe "GET /job_applications when unauthenticated" do
    subject(:make_request) { get job_applications_path }

    it_behaves_like "requires authentication"
  end

  describe "GET /job_applications/:id" do
    before { sign_in_as(user) }

    it "renders a successful response for own application" do
      get job_application_path(user_application)
      expect(response).to be_successful
    end

    it "returns not found for other user's application" do
      get job_application_path(other_application)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /job_applications/:id when unauthenticated" do
    subject(:make_request) { get job_application_path(user_application) }

    it_behaves_like "requires authentication"
  end

  describe "POST /job_applications" do
    before { sign_in_as(user) }

    let(:valid_params) do
      {
        job_application: {
          company_name: "Basecamp",
          position: "Rails Developer",
          status: "applied",
          applied_at: Date.current,
          url: "https://example.com/jobs/rails",
          location: "Remote",
          description: "Build useful software."
        }
      }
    end

    it "creates an application for the current user and redirects to it" do
      expect {
        post job_applications_path, params: valid_params
      }.to change(user.job_applications, :count).by(1)

      created_application = user.job_applications.order(:created_at).last
      expect(response).to redirect_to(job_application_path(created_application))
      expect(flash[:notice]).to eq("Job application was successfully created.")
      expect(created_application.company_name).to eq("Basecamp")
    end

    it "does not create an application with invalid attributes" do
      expect {
        post job_applications_path, params: {
          job_application: valid_params[:job_application].merge(company_name: "")
        }
      }.not_to change(JobApplication, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Company name")
    end

    it "returns bad request when required parameters are missing" do
      expect {
        post job_applications_path, params: { application: valid_params[:job_application] }
      }.not_to change(JobApplication, :count)

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "POST /job_applications when unauthenticated" do
    subject(:make_request) { post job_applications_path, params: { job_application: { company_name: "Acme" } } }

    it_behaves_like "requires authentication"
  end

  describe "PATCH /job_applications/:id" do
    before { sign_in_as(user) }

    it "updates own application" do
      patch job_application_path(user_application), params: { job_application: { company_name: "Apple Updated" } }
      expect(user_application.reload.company_name).to eq("Apple Updated")
      expect(response).to redirect_to(job_application_path(user_application))
    end

    it "does not update own application with invalid attributes" do
      patch job_application_path(user_application), params: { job_application: { company_name: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Company name")
      expect(user_application.reload.company_name).to eq("Apple")
    end

    it "returns bad request when required parameters are missing" do
      patch job_application_path(user_application), params: { application: { company_name: "Ignored" } }

      expect(response).to have_http_status(:bad_request)
      expect(user_application.reload.company_name).to eq("Apple")
    end

    it "returns not found for other user's application" do
      patch job_application_path(other_application), params: { job_application: { company_name: "Hacker Corp" } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /job_applications/:id when unauthenticated" do
    subject(:make_request) { patch job_application_path(user_application), params: { job_application: { company_name: "Acme" } } }

    it_behaves_like "requires authentication"
  end

  describe "DELETE /job_applications/:id" do
    before { sign_in_as(user) }

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

  describe "DELETE /job_applications/:id when unauthenticated" do
    subject(:make_request) { delete job_application_path(user_application) }

    it_behaves_like "requires authentication"
  end

  describe "Nested resources (Notes & Events)" do
    before { sign_in_as(user) }

    it "prevents creating a note for another user's application" do
      post job_application_notes_path(other_application), params: { note: { content: "Sneaky note" } }
      expect(response).to have_http_status(:not_found)
    end

    it "prevents creating an event for another user's application" do
      post job_application_events_path(other_application), params: { event: { title: "Sneaky event", event_type: "call", scheduled_at: Time.current } }
      expect(response).to have_http_status(:not_found)
    end
  end

  def rendered_application_names
    Nokogiri::HTML(response.body).css("#job_applications h5.fw-bold").map { |node| node.text.strip }
  end
end

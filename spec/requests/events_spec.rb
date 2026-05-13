require "rails_helper"

RSpec.describe "Events", type: :request do
  let(:user) { User.create!(email_address: "events@example.com", password: "password", password_confirmation: "password") }
  let(:other_user) { User.create!(email_address: "other-events@example.com", password: "password", password_confirmation: "password") }
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

  describe "POST /job_applications/:job_application_id/events" do
    let(:valid_params) do
      {
        event: {
          title: "Phone Screen",
          event_type: "call",
          scheduled_at: Time.zone.parse("2026-06-01 10:30:00"),
          notes: "Prepare STAR stories"
        }
      }
    end

    it "creates an event and redirects on html success" do
      expect {
        post job_application_events_path(job_application), params: valid_params
      }.to change(Event, :count).by(1)

      expect(response).to redirect_to(job_application_path(job_application))
      expect(flash[:notice]).to eq("Event was successfully created.")
    end

    it "renders a turbo-stream response on success" do
      post job_application_events_path(job_application), params: valid_params,
        headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("turbo-stream")
    end

    it "does not create an event and redirects with alert on html failure" do
      expect {
        post job_application_events_path(job_application), params: {
          event: {
            title: nil,
            event_type: "call",
            scheduled_at: Time.zone.parse("2026-06-01 10:30:00")
          }
        }
      }.not_to change(Event, :count)

      expect(response).to redirect_to(job_application_path(job_application))
      expect(flash[:alert]).to eq("Error creating event.")
    end

    it "returns unprocessable turbo-stream and re-renders form on turbo failure" do
      expect {
        post job_application_events_path(job_application), params: {
          event: {
            title: nil,
            event_type: "call",
            scheduled_at: Time.zone.parse("2026-06-01 10:30:00")
          }
        }, headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
      }.not_to change(Event, :count)

      expect(response).to have_http_status(422)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include('target="new_event"')
      expect(response.body).to include("Please fix the following:")
    end

    it "returns not found for another user's job application" do
      post job_application_events_path(other_application), params: valid_params

      expect(response).to have_http_status(:not_found)
    end

    it "returns bad request when required parameters are missing" do
      expect {
        post job_application_events_path(job_application), params: { title: "Missing wrapper" }
      }.not_to change(Event, :count)

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "POST /job_applications/:job_application_id/events when unauthenticated" do
    before { delete session_path }

    subject(:make_request) { post job_application_events_path(job_application), params: { event: { title: "Private", event_type: "call", scheduled_at: Time.current } } }

    it_behaves_like "requires authentication"
  end
end

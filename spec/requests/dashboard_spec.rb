require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  let(:user) { User.create!(email_address: "user@example.com", password: "password", password_confirmation: "password") }
  let(:other_user) { User.create!(email_address: "other@example.com", password: "password", password_confirmation: "password") }

  describe "GET /" do
    context "when authenticated" do
      before do
        user.job_applications.create!(company_name: "Own App", position: "Dev", status: "offered", applied_at: Date.today)
        user.job_applications.first.events.create!(title: "Own Interview", event_type: "call", scheduled_at: 1.day.from_now)

        3.times do |i|
          other_user.job_applications.create!(company_name: "Other App #{i}", position: "Dev", status: "applied", applied_at: Date.today)
        end
        other_user.job_applications.first.events.create!(title: "Other Interview", event_type: "call", scheduled_at: 1.day.from_now)

        sign_in_as(user)
      end

      it "returns a successful response" do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it "only shows the current user's statistics" do
        get root_path

        expect(response.body).to include("Total Applications")
        expect(response.body).to include("Success Rate")
        expect(response.body).to include(">1</h2>")
        expect(response.body).not_to include(">4</h2>")
      end

      it "calculates success rate based only on current user's data" do
        user.job_applications.create!(company_name: "Second Own App", position: "Dev", status: "rejected", applied_at: Date.today)

        get root_path

        expect(response.body).to include("50.0%")
        expect(response.body).not_to include("20.0%")
      end

      it "only shows the current user's upcoming interviews" do
        get root_path
        expect(response.body).to include("Own Interview")
        expect(response.body).not_to include("Other Interview")
      end

      it "only shows the current user's recent activity" do
        get root_path
        expect(response.body).to include("Own App")
        expect(response.body).not_to include("Other App 0")
      end
    end

    context "when unauthenticated" do
      subject(:make_request) { get root_path }

      it_behaves_like "requires authentication"
    end
  end
end

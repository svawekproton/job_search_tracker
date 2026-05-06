require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let(:user) { User.create!(email_address: "user@example.com", password: "password", password_confirmation: "password") }
  let(:other_user) { User.create!(email_address: "other@example.com", password: "password", password_confirmation: "password") }

  describe "GET /" do
    context "when authenticated" do
      before do
        # Current user: 1 app, 1 offer, 1 interview
        user.job_applications.create!(company_name: "Own App", position: "Dev", status: "offered", applied_at: Date.today)
        user.job_applications.first.events.create!(title: "Own Interview", event_type: "call", scheduled_at: 1.day.from_now)
        
        # Other user: 3 apps, 0 offers, 0 interviews
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
        
        # If scoped correctly, Total should be 1, not 4 (1 + 3)
        # We look for the number inside the h2 tag near the label
        expect(response.body).to include('<h2 class="fw-bold mb-0">1</h2>')
        expect(response.body).not_to include('<h2 class="fw-bold mb-0">4</h2>')
        
        # Offers should be 1, not 1 (wait, let's make it 2 vs 1)
      end

      it "calculates success rate based only on current user's data" do
        # Let's add another app for the user so rate is 50% (1 offer / 2 apps)
        user.job_applications.create!(company_name: "Second Own App", position: "Dev", status: "rejected", applied_at: Date.today)
        
        get root_path
        # Current user: 1 offer / 2 apps = 50%
        # Global: 1 offer / 5 apps = 20%
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
      it "redirects to the login page" do
        get root_path
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end

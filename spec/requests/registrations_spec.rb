require "rails_helper"

RSpec.describe "Registrations", type: :request do
  describe "GET /registrations/new" do
    it "renders a successful response" do
      get new_registration_path
      expect(response).to be_successful
    end
  end

  describe "POST /registrations" do
    context "with valid parameters" do
      let(:valid_attributes) do
        {
          user: {
            email_address: "newuser@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      end

      it "creates a new User" do
        expect {
          post registrations_path, params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it "redirects to the root path" do
        post registrations_path, params: valid_attributes
        expect(response).to redirect_to(root_path)
      end

      it "starts a new session" do
        post registrations_path, params: valid_attributes
        expect(cookies[:session_id]).to be_present
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          user: {
            email_address: "invalid",
            password: "short",
            password_confirmation: "mismatch"
          }
        }
      end

      it "does not create a new User" do
        expect {
          post registrations_path, params: invalid_attributes
        }.to change(User, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post registrations_path, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns bad request when required parameters are missing" do
        expect {
          post registrations_path, params: { email_address: "missing-wrapper@example.com" }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end

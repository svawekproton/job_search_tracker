require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let!(:user) { User.create!(email_address: "test@example.com", password: "password", password_confirmation: "password") }

  describe "GET /session/new" do
    it "renders a successful response" do
      get new_session_path
      expect(response).to be_successful
    end
  end

  describe "POST /session" do
    context "with valid parameters" do
      it "starts a new session and redirects to root" do
        post session_path, params: { email_address: user.email_address, password: "password" }
        expect(response).to redirect_to(root_path)
        expect(cookies[:session_id]).to be_present
      end
    end

    context "with invalid parameters" do
      it "redirects to new_session_path with alert" do
        post session_path, params: { email_address: user.email_address, password: "wrong" }
        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE /session" do
    it "terminates the session and redirects to new_session_path" do
      post session_path, params: { email_address: user.email_address, password: "password" }
      delete session_path
      expect(response).to redirect_to(new_session_path)
      expect(cookies[:session_id]).to be_blank
    end
  end
end

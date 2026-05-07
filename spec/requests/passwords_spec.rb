require "rails_helper"

RSpec.describe "Passwords", type: :request do
  let!(:user) do
    User.create!(email_address: "reset@example.com", password: "password", password_confirmation: "password")
  end

  describe "GET /passwords/new" do
    it "renders a successful response" do
      get new_password_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Forgot password?")
    end
  end

  describe "POST /passwords" do
    it "queues a reset email for an existing user" do
      delivery = instance_double(ActionMailer::MessageDelivery, deliver_later: true)
      expect(PasswordsMailer).to receive(:reset).with(user).and_return(delivery)

      post passwords_path, params: { email_address: user.email_address }

      expect(response).to redirect_to(new_session_path)
      expect(flash[:notice]).to eq("Password reset instructions sent (if user with that email address exists).")
    end

    it "does not queue a reset email for a missing user" do
      expect(PasswordsMailer).not_to receive(:reset)

      post passwords_path, params: { email_address: "missing@example.com" }

      expect(response).to redirect_to(new_session_path)
      expect(flash[:notice]).to eq("Password reset instructions sent (if user with that email address exists).")
    end
  end

  describe "GET /passwords/:token/edit" do
    it "renders a successful response for a valid token" do
      get edit_password_path(user.password_reset_token)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New password")
    end

    it "redirects to forgot password for an invalid token" do
      get edit_password_path("invalid-token")

      expect(response).to redirect_to(new_password_path)
      expect(flash[:alert]).to eq("Password reset link is invalid or has expired.")
    end
  end

  describe "PUT /passwords/:token" do
    it "updates password and clears all sessions on success" do
      user.sessions.create!(user_agent: "RSpec", ip_address: "127.0.0.1")

      put password_path(user.password_reset_token), params: {
        password: "newpassword",
        password_confirmation: "newpassword"
      }

      expect(response).to redirect_to(new_session_path)
      expect(flash[:notice]).to eq("Password has been reset.")
      expect(user.reload.authenticate("newpassword")).to be_present
      expect(user.sessions.count).to eq(0)
    end

    it "redirects back to edit when password confirmation fails" do
      token = user.password_reset_token

      put password_path(token), params: {
        password: "newpassword",
        password_confirmation: "different"
      }

      expect(response).to redirect_to(edit_password_path(token))
      expect(flash[:alert]).to eq("Passwords did not match.")
      expect(user.reload.authenticate("password")).to be_present
    end
  end
end

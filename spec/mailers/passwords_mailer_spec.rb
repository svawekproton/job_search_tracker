require "rails_helper"

RSpec.describe PasswordsMailer, type: :mailer do
  let(:user) do
    User.create!(email_address: "mailer@example.com", password: "password", password_confirmation: "password")
  end

  describe "#reset" do
    subject(:mail) { described_class.reset(user) }

    it "sets the subject and recipients" do
      expect(mail.subject).to eq("Reset your password")
      expect(mail.to).to eq([ user.email_address ])
      expect(mail.from).to eq([ "from@example.com" ])
    end

    it "renders a password reset link in html and text parts" do
      html_body = mail.html_part.body.decoded
      text_body = mail.text_part.body.decoded

      expect(html_body).to include("this password reset page")
      expect(text_body).to include("You can reset your password on")
      expect(html_body).to match(%r{http://example.com/passwords/.+/edit})
      expect(text_body).to match(%r{http://example.com/passwords/.+/edit})
    end
  end
end

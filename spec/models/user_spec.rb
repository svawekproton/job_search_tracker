require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = User.new(email_address: "test@example.com", password: "password", password_confirmation: "password")
      expect(user).to be_valid
    end

    it "is invalid without an email address" do
      user = User.new(email_address: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with a duplicate email address" do
      User.create!(email_address: "test@example.com", password: "password", password_confirmation: "password")
      user = User.new(email_address: "TEST@example.com", password: "password", password_confirmation: "password")
      expect(user).not_to be_valid
    end

    it "is invalid with an incorrect email format" do
      user = User.new(email_address: "invalid-email", password: "password", password_confirmation: "password")
      expect(user).not_to be_valid
    end

    it "is invalid with a short password" do
      user = User.new(email_address: "test@example.com", password: "123", password_confirmation: "123")
      expect(user).not_to be_valid
    end
  end

  describe "associations" do
    it "has many sessions" do
      association = described_class.reflect_on_association(:sessions)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it "has many job_applications" do
      association = described_class.reflect_on_association(:job_applications)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end
end

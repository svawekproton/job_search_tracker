require "rails_helper"

RSpec.describe JobApplicationsHelper, type: :helper do
  describe "#status_badge_classes" do
    it "returns classes for each known status" do
      expect(helper.status_badge_classes(:applied)).to eq("bg-applied text-applied-text")
      expect(helper.status_badge_classes(:interviewing)).to eq("bg-interviewing text-interviewing-text")
      expect(helper.status_badge_classes(:offered)).to eq("bg-offered text-offered-text")
      expect(helper.status_badge_classes(:rejected)).to eq("bg-rejected text-rejected-text")
      expect(helper.status_badge_classes(:withdrawn)).to eq("bg-withdrawn text-withdrawn-text")
    end

    it "returns fallback classes for unknown statuses" do
      expect(helper.status_badge_classes("other")).to eq("bg-light text-dark")
    end
  end

  describe "#status_border_color" do
    it "returns border color for each known status" do
      expect(helper.status_border_color(:applied)).to eq("var(--status-applied-bg)")
      expect(helper.status_border_color(:interviewing)).to eq("var(--status-interviewing-bg)")
      expect(helper.status_border_color(:offered)).to eq("var(--status-offered-bg)")
      expect(helper.status_border_color(:rejected)).to eq("var(--status-rejected-bg)")
      expect(helper.status_border_color(:withdrawn)).to eq("var(--status-withdrawn-bg)")
    end

    it "returns a fallback border color for unknown statuses" do
      expect(helper.status_border_color("other")).to eq("#DEE2E6")
    end
  end

  describe "#combined_activity_for" do
    it "returns notes and events in reverse activity order" do
      user = User.create!(email_address: "activity@example.com", password: "password", password_confirmation: "password")
      job_application = user.job_applications.create!(
        company_name: "Acme",
        position: "Engineer",
        applied_at: Date.current
      )
      older_note = job_application.notes.create!(
        category: "General",
        content: "Older note",
        created_at: Time.zone.local(2026, 1, 1, 9)
      )
      newer_note = job_application.notes.create!(
        category: "Question",
        content: "Newer note",
        created_at: Time.zone.local(2026, 1, 2, 9)
      )
      event = job_application.events.create!(
        title: "Interview",
        event_type: "technical_interview",
        scheduled_at: Time.zone.local(2026, 1, 3, 9)
      )

      expect(helper.combined_activity_for(job_application)).to eq([ event, newer_note, older_note ])
    end
  end

  describe "#safe_external_url" do
    it "returns HTTP and HTTPS URLs" do
      expect(helper.safe_external_url("http://example.com/jobs")).to eq("http://example.com/jobs")
      expect(helper.safe_external_url("https://example.com/jobs")).to eq("https://example.com/jobs")
    end

    it "rejects unsafe and malformed URLs" do
      expect(helper.safe_external_url("javascript:alert(1)")).to be_nil
      expect(helper.safe_external_url("https://")).to be_nil
    end
  end
end

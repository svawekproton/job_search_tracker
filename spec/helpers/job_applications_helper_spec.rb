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
end

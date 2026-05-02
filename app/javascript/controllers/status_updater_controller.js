import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "badge", "card"]
  
  // Mapping of status to Bootstrap classes and colors based on Design Spec
  static classes = {
    applied: { bg: "bg-applied", text: "text-applied-text", color: "var(--status-applied-bg)" },
    interviewing: { bg: "bg-interviewing", text: "text-interviewing-text", color: "var(--status-interviewing-bg)" },
    offered: { bg: "bg-offered", text: "text-offered-text", color: "var(--status-offered-bg)" },
    rejected: { bg: "bg-rejected", text: "text-rejected-text", color: "var(--status-rejected-bg)" },
    withdrawn: { bg: "bg-withdrawn", text: "text-withdrawn-text", color: "var(--status-withdrawn-bg)" }
  }

  update() {
    const status = this.selectTarget.value
    const theme = this.constructor.classes[status]

    if (theme) {
      if (this.hasBadgeTarget) {
        this.badgeTarget.className = `badge ${theme.bg} ${theme.text} fw-bold`
        this.badgeTarget.innerText = status.charAt(0).toUpperCase() + status.slice(1)
      }

      if (this.hasCardTarget) {
        this.cardTarget.style.borderLeftColor = theme.color
      }
    }
  }
}

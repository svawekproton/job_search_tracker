import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "preview" ]

  show() {
    const file = this.inputTarget.files[0]
    if (file) {
      const size = (file.size / 1024).toFixed(1) + " KB"
      this.previewTarget.innerHTML = `<span class="badge bg-light text-dark border"><i class="bi bi-file-earmark me-1"></i> ${file.name} (${size})</span>`
    }
  }
}

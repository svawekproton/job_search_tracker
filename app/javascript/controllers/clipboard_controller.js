import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "source" ]

  copy() {
    this.sourceTarget.select()
    document.execCommand("copy")
    
    // Optional: add visual feedback
    const btn = event.currentTarget
    const originalText = btn.innerHTML
    btn.innerHTML = '<i class="bi bi-check"></i> Copied'
    setTimeout(() => { btn.innerHTML = originalText }, 2000)
  }
}

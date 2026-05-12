import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "source" ]

  async copy(event) {
    const btn = event.currentTarget
    const originalText = btn.innerHTML
    const text = this.sourceTarget.value
    let copied = false

    if (navigator.clipboard?.writeText) {
      try {
        await navigator.clipboard.writeText(text)
        copied = true
      } catch (error) {
        copied = false
      }
    }

    if (!copied) {
      this.sourceTarget.classList.remove("d-none")
      this.sourceTarget.select()
      copied = document.execCommand("copy")
      this.sourceTarget.classList.add("d-none")
    }

    if (copied) {
      btn.innerHTML = '<i class="bi bi-check"></i> Copied'
      setTimeout(() => { btn.innerHTML = originalText }, 2000)
    }
  }
}

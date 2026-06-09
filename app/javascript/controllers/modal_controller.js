import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { selector: String }

  open(event) {
    event.preventDefault()

    const modalElement = document.querySelector(this.selectorValue)
    if (modalElement) {
      window.bootstrap.Modal.getOrCreateInstance(modalElement).show()
    }
  }

  close(event) {
    if (event.detail.success) {
      const modal = window.bootstrap.Modal.getInstance(this.element)
      if (modal) {
        modal.hide()
      }
    }
  }
}

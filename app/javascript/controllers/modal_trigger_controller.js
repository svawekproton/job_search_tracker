import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  open(event) {
    event.preventDefault()

    const modal = document.querySelector(this.element.dataset.bsTarget)
    if (modal) {
      window.bootstrap.Modal.getOrCreateInstance(modal).show()
    }
  }
}

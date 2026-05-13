import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  close(event) {
    if (event.detail.success) {
      const modal = window.bootstrap.Modal.getInstance(this.element)
      if (modal) {
        modal.hide()
      }
    }
  }
}

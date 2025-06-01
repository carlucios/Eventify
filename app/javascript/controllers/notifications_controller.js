import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "count", "list", "emptyMessage", "bell"]

  connect() {
    this.handleOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.handleOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick)
  }

  toggleDropdown(event) {
    event.stopPropagation()
    this.dropdownTarget.classList.toggle("hidden")

    if (!this.dropdownTarget.classList.contains("hidden")) {
      this.countTarget.classList.add("hidden")
      this.countTarget.textContent = ""
    }
  }

  handleOutsideClick(event) {
    if (!this.dropdownTarget.contains(event.target) && !this.bellTarget.contains(event.target)) {
      this.dropdownTarget.classList.add("hidden")
    }
  }
}

import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = ["dropdown", "count", "list", "emptyMessage", "bell"]

  connect() {
    window.notificationsController = this

    this.handleOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.handleOutsideClick)

    this.subscribeToNotifications()
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick)
    this.unsubscribeFromNotifications()
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
    if (
      !this.dropdownTarget.contains(event.target) &&
      !this.bellTarget.contains(event.target)
    ) {
      if (!this.dropdownTarget.classList.contains("hidden")) {
        this.dropdownTarget.classList.add("hidden")

        this.listTarget.querySelectorAll(".new-notification").forEach(el => {
          el.classList.remove("new-notification")
        })
      }
    }
  }

  subscribeToNotifications() {
    if (!window.currentUserId) return

    this.channel = consumer.subscriptions.create("NotificationsChannel", {
      received: (data) => {
        this.handleIncomingNotification(data)
      }
    })
  }

  unsubscribeFromNotifications() {
    if (this.channel) {
      consumer.subscriptions.remove(this.channel)
      this.channel = null
    }
  }

  handleIncomingNotification(data) {
    const li = document.createElement("li")
    li.classList.add("notification-item", "new-notification")
    li.innerHTML = `
      <div class="notification">
        <div>${data.body}</div>
        <span>${data.time}</span>
      </div>
    `
    this.listTarget.prepend(li)

    if (this.hasEmptyMessageTarget) {
      this.emptyMessageTarget.remove()
    }

    const currentCount = parseInt(this.countTarget.textContent || "0", 10)
    this.countTarget.classList.remove("hidden")
    this.countTarget.textContent = currentCount + 1
  }
}

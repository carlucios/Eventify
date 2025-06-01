import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "count", "list", "emptyMessage", "bell"]
  static values = {
    url: String,
    interval: Number
  }

  connect() {
    this.handleOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.handleOutsideClick)

    this.startPolling()
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick)
    this.stopPolling()
  }

  async toggleDropdown(event) {
    event.stopPropagation()
    this.dropdownTarget.classList.toggle("hidden")
  
    if (!this.dropdownTarget.classList.contains("hidden")) {
      await this.fetchNotifications()
  
      this.countTarget.classList.add("hidden")
      this.countTarget.textContent = ""
  
      this.stopPolling()
    }
    else {
      await this.markAllAsRead()
    }
  }  

  handleOutsideClick(event) {
    if (
      !this.dropdownTarget.contains(event.target) &&
      !this.bellTarget.contains(event.target)
    ) {
      this.dropdownTarget.classList.add("hidden")
      this.startPolling()
    }
  }

  startPolling() {
    if (this.polling) {
      return
    }
    const intervalMs = 1000
    this.polling = setInterval(() => {
      this.fetchNotifications()
    }, intervalMs)
  }

  stopPolling() {
    if (this.polling) {
      clearInterval(this.polling)
      this.polling = null
    }
  }

  fetchNotifications() {
    if (!this.urlValue) {
      return
    }
   
    fetch(this.urlValue, { headers: { "Accept": "application/json" } })
    .then(async response => {

      if (!response.ok) {
        const errorText = await response.text()
        console.error(`[Notifications] Erro na resposta: ${errorText}`)
        throw new Error("Erro ao buscar notificações")
      }
      return response.json()
    })
    .then(data => {
  
      if (data.html) {
        const tempDiv = document.createElement("div")
        tempDiv.innerHTML = data.html.trim()
  
        const ul = tempDiv.querySelector("ul#notifications-list")
  
        if (ul) {
          this.listTarget.innerHTML = ul.innerHTML
        } else {
          this.listTarget.innerHTML = data.html
        }

        const unreadCount = data.unread_count
        if (unreadCount > 0) {
          this.countTarget.classList.remove("hidden")
          this.countTarget.textContent = unreadCount
        } else {
          this.countTarget.classList.add("hidden")
          this.countTarget.textContent = ""
        }

        const count = this.listTarget.querySelectorAll("li").length

        if (count > 0) {
          if (this.hasEmptyMessageTarget) {
            this.emptyMessageTarget.remove()
          }
        } else {
          this.showEmptyMessage()
        }
      } else {
        this.showEmptyMessage()
      }
    })
  }  

  showEmptyMessage() {
    this.listTarget.innerHTML = ""
  
    if (!this.hasEmptyMessageTarget) {
      const emptyLi = document.createElement("li")
      emptyLi.textContent = "Você não possui notificações"
      emptyLi.classList.add("no-notifications")
      emptyLi.dataset.notificationsTarget = "emptyMessage"
      this.listTarget.appendChild(emptyLi)
    }
  }  

  updateNotifications(notifications) {
    this.listTarget.innerHTML = ""

    if (!notifications.length) {
      this.showEmptyMessage()
      return
    }

    if (this.hasEmptyMessageTarget) {
      this.emptyMessageTarget.remove()
    }

    notifications.forEach(html => {
      const li = document.createElement("li")
      li.innerHTML = html
      this.listTarget.appendChild(li)
    })

    this.countTarget.classList.remove("hidden")
    this.countTarget.textContent = notifications.length
  }

  async markAllAsRead() {
    const url = this.urlValue.replace(/\.json$/, "/mark_all_as_read.json")
  
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  
    try {
      const response = await fetch(url, {
        method: "PATCH",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken
        }
      })
  
  
      if (!response.ok) throw new Error("Erro ao marcar notificações como lidas")
    } catch (error) {
      console.error("[Notifications] Erro ao marcar como lidas:", error)
    }
  }  
}

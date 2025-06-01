import consumer from "./consumer"

const userId = document.querySelector("meta[name='current-user-id']")?.content

if (userId) {
  consumer.subscriptions.create({ channel: "NotificationsChannel", id: userId }, {
    connected() {
      console.log("Conectado ao canal de notificações do usuário " + userId)
    },

    disconnected() {
      console.log("Desconectado do canal de notificações.")
    },

    received(data) {
      const list = document.querySelector("#notifications-list")
      const count = document.querySelector("#notification-count")
      const empty = document.querySelector("[data-notifications-target='emptyMessage']")

      if (empty) empty.remove()

      const li = document.createElement("li")
      li.innerHTML = data.html
      list.prepend(li)

      if (count) {
        count.classList.remove("hidden")
        const current = parseInt(count.textContent || "0")
        count.textContent = current + 1
      }
    }
  })
}

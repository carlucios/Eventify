import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("Conectado ao canal de notificações.")
  },

  disconnected() {
    console.log("Desconectado do canal de notificações.")
  },

  received(data) {
    console.log("Nova notificação recebida.")
  }
})

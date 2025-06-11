import consumer from "channels/consumer"

consumer.subscriptions.create("FooterStatusChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to FooterStatusChannel");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Atualiza o conteúdo do footer_status turbo-frame (ou div)
    const footer = document.getElementById("footer_status");
    if (footer) {
      footer.innerHTML = `
        <div class="status" style="text-align: center; margin-top: 1rem; color: #333;">
          ${data.message}
        </div>
      `;
    }
  }
});

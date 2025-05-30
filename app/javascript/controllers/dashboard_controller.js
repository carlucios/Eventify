import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["details"]

  async loadDetails(event) {
    const url = event.currentTarget.dataset.dashboardUrl

    try {
      const response = await fetch(url, {
        headers: {
          "Accept": "text/vnd.turbo-stream.html"
        }
      })

      if (response.ok) {
        const html = await response.text()
        document.querySelector("#details-container").innerHTML = html
      } else {
        console.error("Failed to load details")
      }
    } catch (e) {
      console.error("Error loading:", e)
    }
  }
}

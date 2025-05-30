import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["forYou", "explore", "forYouTab", "exploreTab"]

  connect() {
    this.showForYou()
  }

  showForYou() {
    this.forYouTarget.classList.remove("hidden")
    this.exploreTarget.classList.add("hidden")
    this.forYouTabTarget.classList.add("active")
    this.exploreTabTarget.classList.remove("active")
  }

  showExplore() {
    this.forYouTarget.classList.add("hidden")
    this.exploreTarget.classList.remove("hidden")
    this.forYouTabTarget.classList.remove("active")
    this.exploreTabTarget.classList.add("active")
  }
}

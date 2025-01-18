import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    this.closeOnOutsideClick = this.closeOnOutsideClick.bind(this);
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden");
    document.addEventListener("click", this.closeOnOutsideClick);
  }

  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
      document.removeEventListener("click", this.closeOnOutsideClick);
    }
  }
}
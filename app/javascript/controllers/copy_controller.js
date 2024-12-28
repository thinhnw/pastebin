import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="copy"
export default class extends Controller {
  static targets = ["source"];
  connect() {
    console.log("Hello, Stimulus!", this.element)
  }
  copy() {
    const textToCopy = this.sourceTarget.textContent || this.sourceTarget.value;
    navigator.clipboard.writeText(textToCopy).then(() => {
      alert("Copied to clipboard!");
    }).catch(err => {
      console.error("Failed to copy: ", err);
    })
  }
}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    text: String
  }

  copy() {
    navigator.clipboard.writeText(this.textValue).then(() => {
      // Optional: You could add some visual feedback here
      const originalText = this.element.textContent;
      this.element.textContent = "Copied!";
      
      setTimeout(() => {
        this.element.textContent = originalText;
      }, 1000);
    }).catch(err => {
      console.error('Failed to copy text: ', err);
    });
  }
}

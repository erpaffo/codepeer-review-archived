import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "@rails/activestorage";

export default class extends Controller {
  static targets = ["input", "attachments"];

  connect() {
    this.inputTarget.addEventListener("change", (event) => {
      this.uploadFiles(event.target.files);
    });
  }

  uploadFiles(files) {
    Array.from(files).forEach((file) => {
      const upload = new DirectUpload(file, this.directUploadUrl);
      upload.create((error, blob) => {
        if (error) {
          console.error(error);
        } else {
          this.appendBlobToAttachments(blob);
        }
      });
    });
  }

  get directUploadUrl() {
    return this.inputTarget.getAttribute("data-direct-upload-url");
  }

  appendBlobToAttachments(blob) {
    const hiddenField = document.createElement("input");
    hiddenField.setAttribute("type", "hidden");
    hiddenField.setAttribute("value", blob.signed_id);
    hiddenField.name = this.inputTarget.name;
    this.attachmentsTarget.appendChild(hiddenField);
  }
}

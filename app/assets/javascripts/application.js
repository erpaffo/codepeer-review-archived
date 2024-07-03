import "editor"
import "./upload_file"
import { Turbo } from "@hotwired/turbo-rails"

Turbo.start()

document.addEventListener("DOMContentLoaded", function() {
  console.log("JavaScript loaded!");
});

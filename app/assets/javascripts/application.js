import "./editor";
import { Turbo } from "@hotwired/turbo-rails";
import { Application } from "@hotwired/stimulus";
import * as ActiveStorage from "@rails/activestorage";
import FileUploadController from "./file_upload_controller";

const application = Application.start();
application.register("file-upload", FileUploadController);

ActiveStorage.start();
Turbo.start();

document.addEventListener("DOMContentLoaded", function() {
  console.log("JavaScript loaded!");
});


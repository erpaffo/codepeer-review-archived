// app/assets/javascripts/editor.js
import * as monaco from 'monaco-editor';

document.addEventListener("DOMContentLoaded", function() {
  const editorElement = document.getElementById('editor');
  if (editorElement) {
    const editor = monaco.editor.create(editorElement, {
      value: editorElement.textContent,
      language: 'ruby',
      theme: 'vs-dark',
    });

    const form = editorElement.closest('form');
    if (form) {
      const contentField = form.querySelector('textarea[name="content"]');
      if (contentField) {
        form.addEventListener('submit', function() {
          contentField.value = editor.getValue();
        });
      }
    }
  }
});

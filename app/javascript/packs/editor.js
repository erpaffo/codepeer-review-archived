import * as monaco from 'monaco-editor';

document.addEventListener("DOMContentLoaded", function() {
  const editorElement = document.getElementById('editor');
  if (editorElement) {
    const editor = monaco.editor.create(editorElement, {
      value: editorElement.dataset.content,
      language: 'javascript',  // Change language as needed
      theme: 'vs-dark',
    });

    document.querySelector('form').addEventListener('submit', function() {
      editorElement.value = editor.getValue();
    });
  }
});

// app/javascript/packs/code_editor.js
import CodeMirror from 'codemirror';
import 'codemirror/mode/javascript/javascript';
import 'codemirror/lib/codemirror.css';


document.addEventListener('DOMContentLoaded', () => {
    const editor = CodeMirror.fromTextArea(document.getElementById('code-editor'), {
      lineNumbers: true,
      mode: 'javascript',
      theme: 'default',
    });
  
    document.getElementById('save-btn').addEventListener('click', () => {
      const code = editor.getValue();
      // Implement code to save the snippet
      console.log('Code saved:', code);
    });
  
    document.getElementById('load-btn').addEventListener('click', () => {
      // Implement code to load the snippet
      const code = 'console.log("Hello, World!");'; // Example code
      editor.setValue(code);
    });
  
    document.getElementById('run-btn').addEventListener('click', () => {
      const code = editor.getValue();
      try {
        eval(code); // Run the code (use with caution in production)
      } catch (error) {
        console.error('Error running code:', error);
      }
    });
  });
  
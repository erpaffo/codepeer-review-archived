import CodeMirror from 'codemirror';
import 'codemirror/mode/javascript/javascript';
import 'codemirror/mode/python/python';
import 'codemirror/mode/ruby/ruby';
import 'codemirror/mode/clike/clike';
import 'codemirror/lib/codemirror.css';
import 'codemirror/theme/dracula.css';

document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll('[data-codemirror]').forEach((textarea) => {
    CodeMirror.fromTextArea(textarea, {
      lineNumbers: true,
      mode: 'javascript',
      theme: 'dracula',
    });
  });
});

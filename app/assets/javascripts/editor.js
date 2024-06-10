document.addEventListener("DOMContentLoaded", function() {
  require.config({ paths: { 'vs': 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.21.2/min/vs' }});

  require(['vs/editor/editor.main'], function() {
    const editorElement = document.getElementById('editor');
    const editorContainerElement = document.getElementById('editor-container');
    const fileContentElement = document.getElementById('file-content');
    const sidebarElement = document.getElementById('sidebar');
    const mainContentElement = document.getElementById('main-content');
    const sidebarRightElement = document.getElementById('sidebar-right');
    const toggleButton = document.getElementById('toggle-button');
    const resizerLeft = document.getElementById('resizer-left');
    const resizerEditor = document.getElementById('resizer-editor');
    const runCodeButton = document.getElementById('run-code-button');

    if (!editorElement) console.error("editorElement is missing");
    if (!editorContainerElement) console.error("editorContainerElement is missing");
    if (!fileContentElement) console.error("fileContentElement is missing");
    if (!sidebarElement) console.error("sidebarElement is missing");
    if (!mainContentElement) console.error("mainContentElement is missing");
    if (!sidebarRightElement) console.error("sidebarRightElement is missing");
    if (!toggleButton) console.error("toggleButton is missing");
    if (!resizerLeft) console.error("resizerLeft is missing");
    if (!resizerEditor) console.error("resizerEditor is missing");
    if (!runCodeButton) console.error("runCodeButton is missing");

    if (!editorElement || !editorContainerElement || !fileContentElement || !sidebarElement || !mainContentElement || !sidebarRightElement || !toggleButton || !runCodeButton) {
      console.error("One or more elements are missing from the DOM");
      return;
    }

    console.log("All necessary elements are present in the DOM");

    let isResizing = false;
    let isResizingEditor = false;
    let editor;

    if (resizerLeft) {
      resizerLeft.addEventListener('mousedown', function(e) {
        isResizing = true;
        document.addEventListener('mousemove', resizeSidebar);
        document.addEventListener('mouseup', stopResizing);
      });
    }

    function resizeSidebar(e) {
      if (isResizing) {
        const newWidth = e.clientX - sidebarElement.offsetLeft;
        sidebarElement.style.width = `${newWidth}px`;
        mainContentElement.style.marginLeft = `${newWidth}px`;
        updateEditorWidth();
      }
    }

    function stopResizing() {
      isResizing = false;
      document.removeEventListener('mousemove', resizeSidebar);
      document.removeEventListener('mouseup', stopResizing);
    }

    if (toggleButton) {
      toggleButton.addEventListener('click', function() {
        sidebarElement.classList.toggle('collapsed');
        mainContentElement.classList.toggle('expanded');
        setTimeout(() => {
          updateEditorWidth();
        }, 300);
      });
    }

    if (resizerEditor) {
      resizerEditor.addEventListener('mousedown', function(e) {
        isResizingEditor = true;
        document.addEventListener('mousemove', resizeEditor);
        document.addEventListener('mouseup', stopResizingEditor);
      });
    }

    function resizeEditor(e) {
      if (isResizingEditor) {
        const newWidth = e.clientX - mainContentElement.offsetLeft;
        editorContainerElement.style.width = `${newWidth}px`;
        if (editor) {
          editor.layout();
        }
      }
    }

    function stopResizingEditor() {
      isResizingEditor = false;
      document.removeEventListener('mousemove', resizeEditor);
      document.removeEventListener('mouseup', stopResizingEditor);
    }

    function updateEditorWidth() {
      const rightSidebarWidth = sidebarRightElement.offsetWidth;
      const containerWidth = mainContentElement.offsetWidth;
      const newWidth = containerWidth - rightSidebarWidth;
      editorContainerElement.style.width = `${newWidth}px`;
      if (editor) {
        editor.layout();
      }
    }

    if (editorElement && fileContentElement) {
      editor = monaco.editor.create(editorElement, {
        value: fileContentElement.value,
        language: 'ruby',
        theme: 'vs-dark',
      });

      console.log("Monaco Editor created successfully");

      const form = editorElement.closest('form');
      if (form) {
        const contentField = form.querySelector('textarea[name="content"]');
        if (contentField) {
          form.addEventListener('submit', function() {
            contentField.value = editor.getValue();
          });
        }
      }

      // Initial layout
      setTimeout(() => {
        updateEditorWidth();
      }, 0);
    }

    window.addEventListener('resize', function() {
      updateEditorWidth();
    });
  });
});

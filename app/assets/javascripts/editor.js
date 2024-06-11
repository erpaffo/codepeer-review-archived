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
    const saveFileButton = document.getElementById('save-file-button');
    const managePackagesButton = document.getElementById('manage-packages-button');
    const packageManagerModal = document.getElementById('package-manager');
    const closeButton = document.querySelector('.close-button');
    const savePackagesButton = document.getElementById('save-packages-button');
    const packageList = document.getElementById('package-list');

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
    let language = 'plaintext';
    let packages = [];

    const extensionLanguageMap = {
      'py': 'python',
      'rb': 'ruby',
      'c': 'c',
      'cpp': 'cpp',
      'ts': 'typescript',
      'r': 'r',
      'kt': 'kotlin',
      'go': 'go',
      'rs': 'rust',
      // Aggiungi altre estensioni e linguaggi qui se necessario
    };

    const fileExtension = (filePath) => filePath ? filePath.split('.').pop() : '';

    const determineLanguage = (filePath) => {
      const ext = fileExtension(filePath);
      return extensionLanguageMap[ext] || 'plaintext';
    };

    language = determineLanguage(fileContentElement.dataset.filePath);

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
        language: language,
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

    runCodeButton.addEventListener('click', function() {
      const code = editor.getValue();
      const language = determineLanguage(fileContentElement.dataset.filePath);
      const repository = fileContentElement.dataset.repository;

      fetch('/run_code', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ code: code, language: language, packages: packages, repository: repository })
      })
      .then(response => response.json())
      .then(data => {
        const outputElement = document.getElementById('output');
        outputElement.textContent = data.output;
      });
    });

    // Package manager modal
    managePackagesButton.addEventListener('click', function() {
      packageManagerModal.style.display = "block";
    });

    closeButton.addEventListener('click', function() {
      packageManagerModal.style.display = "none";
    });

    window.addEventListener('click', function(event) {
      if (event.target == packageManagerModal) {
        packageManagerModal.style.display = "none";
      }
    });

    savePackagesButton.addEventListener('click', function() {
      packages = Array.from(document.querySelectorAll('input[name="packages[]"]:checked')).map(el => el.value);
      packageManagerModal.style.display = "none";
    });
  });
});

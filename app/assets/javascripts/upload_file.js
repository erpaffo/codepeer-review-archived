document.addEventListener('DOMContentLoaded', () => {
    const input = document.querySelector('input[type="file"][multiple]');
    if (input) {
      input.addEventListener('change', handleFileSelect, false);
    }
  });
  
  function handleFileSelect(event) {
    const input = event.target;
    const files = input.files;
    const fileList = document.createElement('ul');
  
    for (let i = 0; i < files.length; i++) {
      const li = document.createElement('li');
      li.textContent = files[i].name;
      fileList.appendChild(li);
    }
  
    const existingList = document.querySelector('ul');
    if (existingList) {
      existingList.replaceWith(fileList);
    } else {
      input.insertAdjacentElement('afterend', fileList);
    }
  }
  
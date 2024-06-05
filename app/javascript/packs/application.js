document.addEventListener("DOMContentLoaded", function() {
  const profilePictureInput = document.getElementById('profile-picture-input');
  const profilePicturePreview = document.getElementById('profile-picture-preview');

  profilePictureInput.addEventListener('change', function() {
    const file = this.files[0];
    if (file && file.size <= 1048576) { // 1 MB limit
      const reader = new FileReader();
      reader.onload = function(e) {
        profilePicturePreview.src = e.target.result;
        profilePicturePreview.style.display = 'block';
      }
      reader.readAsDataURL(file);
    } else {
      alert("Image must be less than 1MB");
      profilePictureInput.value = ''; // Clear the input
      profilePicturePreview.style.display = 'none';
    }
  });
});

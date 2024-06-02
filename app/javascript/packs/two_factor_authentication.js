document.addEventListener('DOMContentLoaded', () => {
    const methodSelect = document.getElementById('two_factor_method');
    const phoneNumberField = document.getElementById('phone_number_field');
    const appQrCode = document.getElementById('app-qr-code');
  
    methodSelect.addEventListener('change', (event) => {
      const selectedMethod = event.target.value;
      if (selectedMethod === 'sms') {
        phoneNumberField.style.display = 'block';
      } else {
        phoneNumberField.style.display = 'none';
      }
    });
  
    // Trigger change event to set initial visibility
    methodSelect.dispatchEvent(new Event('change'));
  });
  
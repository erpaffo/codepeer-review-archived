document.addEventListener('DOMContentLoaded', () => {
    const methodSelect = document.getElementById('two_factor_method');
    const phoneNumberField = document.getElementById('phone_number_field');
    const appQrCode = document.getElementById('app_qr_code');
  
    if (methodSelect) {
      methodSelect.addEventListener('change', (event) => {
        const selectedMethod = event.target.value;
        if (selectedMethod === 'sms') {
          phoneNumberField.style.display = 'block';
          if (appQrCode) appQrCode.style.display = 'none';
        } else if (selectedMethod === 'app') {
          phoneNumberField.style.display = 'none';
          if (appQrCode) appQrCode.style.display = 'block';
        } else {
          phoneNumberField.style.display = 'none';
          if (appQrCode) appQrCode.style.display = 'none';
        }
      });
  
      // Trigger change event to set initial visibility
      methodSelect.dispatchEvent(new Event('change'));
    }
  });
  
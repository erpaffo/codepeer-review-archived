# Codepeer Review

Progetto per il Lab di Sicurezza del gruppo formato da Francesco Paffetti 1982282(@sassoanarchico, @erpaffo), Alessadnro Vario 1985025 (), Edoardo Zompanti 1985499 ().

Per importare ed eseguire il codice eseguire i seguenti comandi:
Se si utilizza SSH (scelta consigliata per poter pushare più facilmente i file), bisogna eseguire i seguenti comandi:
1. Per generare la ssh-key bisogna eseguire il seguente comando. Nel terminale, inserire una passphrase o cliccare invio se non si vuole inserire
  ```bash
  ssh-keygen -t ed25519 -C "your_email@example.com"
  ```
2. Starta in background ssh-agent
  ```bash
  eval "$(ssh-agent -s)"
  ```
3. Aggiungi la tua chiave privata SSH a ssh-agent e memorizza la tua passphrase nel portachiavi
  ```bash
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  ```
4. Copia la tua ssh key
  ```bash
  pbcopy < ~/.ssh/id_ed25519.pub
  ```
5. Vai sul tuo account github e in settings/ssh inserisce la ssh key
6. Importare il progetto sul proprio computer.
   ```bash
   git clone git@github.com:erpaffo/codepeer-review.git
   ```
Altrimenti si può utilizzare HTTPS:
1. Clonare il progetto
  ```bash
  git clone https://github.com/erpaffo/codepeer-review.git
  ```
2. Per pushare andare sulle settings/Developer_settings/personal_access_token/token(Classic)
3. Generare un nuovo token spuntando la categoria 'repo`
4. Quando viene eseguito `git push` inserire come password il token generato

---
Per eseguire il progetto bisogna:
1. Creare il file `application.yml` e inserire le credenziale delle API (come oauth e githb). In particolare, inserire le seguenti credenziali
   ```ruby
   GMAIL_USERNAME: ""
   GMAIL_PASSWORD: ""
  
   DEVISE_OTP_SECRET_ENCRYPTION_KEY: ""
    
   GOOGLE_CLIENT_ID: ""
   GOOGLE_CLIENT_SECRET: ""
   GITHUB_CLIENT_ID: ""
   GITHUB_CLIENT_SECRET: " 
    
   ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY: ""
   ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY: ""
   ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT: ""
    
   TWILIO_ACCOUNT_SID: ""
   TWILIO_AUTH_TOKEN: ""
   TWILIO_PHONE_NUMBER: ""
   MAILER_EMAIL: ""
   ```
2. Assicurarsi di avere i seguenti pacchetti: `nodejs`, per poter eseguire javascript e `yarn` o `npm` 
3. Eseguire i seguenti comandi:
   ```bash
   bundle install
   yarn install #oppure "npm install"
   rails db:migrate
   ```

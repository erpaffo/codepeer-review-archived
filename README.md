# Codepeer Review
Progetto per il "Laboratorio di Applicazioni Software e Sicurezza Informatica" dell'Università "La Sapienza" del gruppo formato da Francesco Paffetti 1982282(@sassoanarchico, @erpaffo), Alessandro Vario 1985025 (), Edoardo Zompanti 1985499 ().

---
## Descrizione
Codepeer Review è un'applicazione web progettata per facilitare la revisione del codice tra sviluppatori. L?obiettivo principale è quello di creare una piattaforma collaborativa dove gli sviluppatori possono condividere il proprio codice, ricevere feedback e migliorare le loro competenze attraverso il processo di "peer review" (*revisione tra pari*). La piattaforma integra funzioknalità di autenticazione tramite GitHub, consentendo agli utenti di connettersi facilmente e di accedere ai loro repository privati e pubblici. Gli utenti possono navigare tra i file dei loro progetti, modificarli direttamente dall'interfaccia web e salvare le modifiche. Per ogni modifica effettuaata viene creato uno snippet che viene aggiunto all'account dell'utente e indica la modifica effettuata dall'utente a quel determinato file

---
## Scaricare il progetto
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
## Modifiche per eseguire
Per eseguire il progetto bisogna:
1. Creare il file `application.yml` nella cartella `config` e inserire le credenziale delle API (come oauth e github). In particolare, inserire le seguenti credenziali
   ```ruby
   GMAIL_USERNAME: ""
   GMAIL_PASSWORD: ""
  
   DEVISE_OTP_SECRET_ENCRYPTION_KEY: ""
    
   GOOGLE_CLIENT_ID: ""
   GOOGLE_CLIENT_SECRET: ""
   GITHUB_CLIENT_ID: ""
   GITHUB_CLIENT_SECRET: ""
    
   ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY: ""
   ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY: ""
   ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT: ""
    
   TWILIO_ACCOUNT_SID: ""
   TWILIO_AUTH_TOKEN: ""
   TWILIO_PHONE_NUMBER: ""
   MAILER_EMAIL: ""
   ```
2. Assicurarsi di avere i seguenti pacchetti: `nodejs`, per poter eseguire javascript, e `yarn` o `npm`, per installare i pacchetti javascript
3. Eseguire i seguenti comandi per completare il setup:
   ```bash
   bundle install # -> installa tutte le gemme
   yarn install #oppure "npm install" ->  installa tutti i pacchetti javascript presenti nel file *package.json*
   rails db:migrate # -> crea il database eseguendo le migrazioni
   ```
4. Eseguire il server
   ```bash
   rails server
   ```

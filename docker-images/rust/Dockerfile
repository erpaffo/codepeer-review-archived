# Usa l'immagine base di Rust
FROM rust:latest

# Imposta la directory di lavoro
WORKDIR /code

# Copia tutti i file del contesto corrente nella directory di lavoro del container
COPY . /code

# Comando per compilare il codice Rust e creare un file eseguibile, quindi eseguirlo
CMD ["sh", "-c", "rustc /code/code.rs -o /code/code.out && chmod +x /code/code.out && /code/code.out"]

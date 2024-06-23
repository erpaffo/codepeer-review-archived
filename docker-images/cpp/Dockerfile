# Usa l'immagine base di GCC
FROM gcc:latest

# Imposta la directory di lavoro
WORKDIR /code

# Copia tutti i file del contesto corrente nella directory di lavoro del container
COPY . /code

# Comando per compilare il codice C++ e creare un file eseguibile, quindi eseguirlo
CMD ["sh", "-c", "g++ /code/code.cpp -o /code/code.out && chmod +x /code/code.out && /code/code.out"]

# docker-images/c/Dockerfile
FROM gcc:latest

WORKDIR /code

COPY . /code

# Compila il codice di default e crea un file eseguibile
CMD ["sh", "-c", "gcc /code/code.c -o /code/code.out && chmod +x /code/code.out && /code/code.out"]

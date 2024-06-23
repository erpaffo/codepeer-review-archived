# docker-images/python/Dockerfile
FROM python:3.9-slim

WORKDIR /code

#COPY requirements.txt .

#RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Aggiungi questa riga per dare i permessi di esecuzione ai file nella directory /code
RUN chmod -R +x /code

ENTRYPOINT ["python", "/code/code.py"]

# docker-images/python/Dockerfile
FROM python:3.8-slim

WORKDIR /code

COPY requirements.txt /code/

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

CMD ["python", "code.py"]

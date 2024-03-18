# FROM python:3.10-slim-buster
FROM python:3.10-slim-bookworm
ENV HNSWLIB_NO_NATIVE=1

RUN mkdir /app
WORKDIR /app
COPY . /app

RUN apt-get update --fix-missing && apt-get install -y --fix-missing build-essential && \
    pip install --upgrade pip setuptools

RUN export HNSWLIB_NO_NATIVE=1
RUN pip install -r requirements.txt

# Expose the Dapr sidecar port
EXPOSE 8602

ENTRYPOINT [ "python", "-u", "./main.py" ]

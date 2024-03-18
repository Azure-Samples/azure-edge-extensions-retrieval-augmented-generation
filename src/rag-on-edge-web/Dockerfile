FROM python:3.10-slim-bullseye

WORKDIR /app
COPY . /app

RUN apt-get update && \
    apt-get install git --yes && \
    pip install --upgrade pip setuptools

RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

EXPOSE 80

ENTRYPOINT ["streamlit", "run", "page_home.py", "--server.port=8501", "--server.address=0.0.0.0"]

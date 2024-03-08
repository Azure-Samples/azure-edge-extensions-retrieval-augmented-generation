FROM python:3.8-slim

# Set the working directory
WORKDIR /app
COPY requirements.txt ./

RUN pip3 install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Expose the Dapr sidecar port
EXPOSE 8701

COPY . .

ENTRYPOINT [ "python3", "-u", "./main.py" ]

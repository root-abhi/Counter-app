FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    curl \
    nginx \
    python3 \
    python3-pip \
    libnginx-mod-http-lua \
    && rm -rf /var/lib/apt/lists/*

COPY old-foxapp.conf /etc/nginx/conf.d/default.conf

RUN rm -rf /etc/nginx/sites-available/*; rm /etc/nginx/sites-enabled/*
RUN mkdir -p /app

COPY main.py /app/main.py
COPY requirements.txt /app/requirements.txt

RUN pip3 install --no-cache-dir -r /app/requirements.txt

EXPOSE 80
EXPOSE 8000
EXPOSE 8080

CMD service nginx start && python3 /app/main.py



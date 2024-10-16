FROM --platform=linux/amd64 python:3.9-slim

WORKDIR /app
RUN apt-get update && apt-get install -y curl wget && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

ENV EXPORTER_PORT=8001
ENV SERVER_URL=http://foxapp-service.ltx.svc:8000

EXPOSE ${EXPORTER_PORT}

CMD ["python", "main.py"]


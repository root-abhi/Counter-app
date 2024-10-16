FROM --platform=linux/amd64 ubuntu:20.04

RUN apt-get update && apt-get install -y curl wget  bash && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/prometheus/prometheus/releases/download/v2.47.0/prometheus-2.47.0.linux-amd64.tar.gz \
    && tar -xvzf prometheus-2.47.0.linux-amd64.tar.gz \
    && mv prometheus-2.47.0.linux-amd64/prometheus /bin/prometheus \
    && mv prometheus-2.47.0.linux-amd64/promtool /bin/promtool \
    && rm -rf prometheus-2.47.0.linux-amd64.tar.gz prometheus-2.47.0.linux-amd64

COPY prometheus.yml /etc/prometheus/prometheus.yml

EXPOSE 9090

CMD ["/bin/prometheus", "--config.file=/etc/prometheus/prometheus.yml"]


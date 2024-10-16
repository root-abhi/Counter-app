from prometheus_client import start_http_server
from prometheus_client.core import REGISTRY, GaugeMetricFamily
import json
import requests
import time
import os
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

EXPORTER_PORT = int(os.getenv('EXPORTER_PORT', 8001))  
SERVER = os.getenv('SERVER_URL')  

class CustomCollector(object):
    def __init__(self, endpoint):
        self._endpoint = endpoint

    def collect(self):
        try:
            response = requests.get(self._endpoint)
            response.raise_for_status()  
            response_data = response.json()
            
            foxes_count = response_data['components']['foxes']['count']
            foxes_count_metric = GaugeMetricFamily('foxes_count_total', 'Total number of foxes', value=foxes_count)
            
            yield foxes_count_metric
        
        except (requests.RequestException, KeyError, json.JSONDecodeError) as e:
            logging.error(f"Error fetching data from {self._endpoint}: {e}")

if __name__ == '__main__':
    logging.info(f"Starting exporter on port {EXPORTER_PORT}")
    start_http_server(EXPORTER_PORT)

    REGISTRY.register(CustomCollector(SERVER))

    while True:
        time.sleep(1)


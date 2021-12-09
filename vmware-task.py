#!/usr/bin/python3
import requests
import time
import sys
from prometheus_client.core import GaugeMetricFamily, REGISTRY 
from prometheus_client import start_http_server


class CustomCollector(object):

    def __init__(self):
        pass

    def get_status_code(self,url):
        result = []
        try:
            r = requests.head(url) 
            if r.status_code == 503:
                return_up_state = 0
            elif r.status_code == 200:
                return_up_state = 1
            else:
                return_up_state = -1
            return [return_up_state, r.elapsed.total_seconds() * 1000]
        except requests.ConnectionError:
            print("ERROR: failed to connect " + url, file=sys.stderr)
            return [-1, -1]

    def collect(self):

        check_urls = ['https://httpstat.us/503', 'https://httpstat.us/200']
        for url in check_urls:
            scheck = self.get_status_code(url)
            value = GaugeMetricFamily('sample_external_url_up', 'Check exit code of url', labels=['url'])
            value.add_metric([url], scheck[0])
            value2 = GaugeMetricFamily('sample_external_url_response_ms', 'Responce time in ms', labels=['url'])
            value2.add_metric([url],scheck[1])
            yield value
            yield value2

if __name__ == '__main__':
    start_http_server(8000)
    REGISTRY.register(CustomCollector())
    while True:
        time.sleep(60)


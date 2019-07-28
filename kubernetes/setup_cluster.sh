helm upgrade prometheus charts/prometheus/ --install
helm upgrade grafana charts/grafana/ --install
helm dep update charts/efk
helm upgrade efk charts/efk/ --install
helm dep update charts/crawler
helm upgrade crawler charts/crawler/ --install

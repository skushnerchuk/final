helm upgrade prometheus charts/prometheus/ --install
helm upgrade grafana charts/grafana/ --install
helm dep update charts/efk
helm upgrade efk charts/efk/ --install
helm dep update charts/rabbitmongo
helm upgrade rm charts/rabbitmongo --install
helm upgrade ui charts/ui --install --set mongodbHost=rm-mongodb
helm upgrade bot charts/bot --install --set mongodbHost=rm-mongodb --set rabbitmqHost=rm-rabbitmq

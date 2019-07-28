helm upgrade prometheus1 charts/prometheus/ --install --namespace review
helm upgrade grafana11 charts/grafana/ --install --namespace review
helm dep update charts/efk
helm upgrade efk1 charts/efk/ --install --namespace review
helm dep update charts/rabbitmongo
helm upgrade rm1 charts/rabbitmongo  --install --namespace review
helm upgrade ui1 charts/ui --install --set mongodbHost=rm-mongodb --namespace review
helm upgrade bot1 charts/bot --install --set mongodbHost=rm-mongodb --set rabbitmqHost=rm-rabbitmq --namespace review

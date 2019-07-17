Набор команд для запуска проекта:
```bash
cd terraform
terraform init
terraform apply
cd ../kubernetes/
helm upgrade prometheus charts/prometheus/ --install
helm upgrade grafana charts/grafana/ --install


helm dep update charts/efk
helm upgrade efk charts/efk/ --install

helm dep update charts/crawler
helm upgrade crawler charts/crawler/ --install
```

Найти IP-адрес, выданный nginx’у
```
kubectl get svc
```

Add the elastic helm charts repo
```
helm repo add elastic https://helm.elastic.co
helm fetch --untar elastic/elasticsearch --version 7.2.0
```
Install it
helm install --name elasticsearch elastic/elasticsearch --version 7.2.0


### Ссылки на приложение и служебные сервисы
* http://nginx.weisdd.space - ui для бота;
* http://grafana.weisdd.space - grafana;
* http://prometheus-server.weisdd.space - prometheus.
* http://kibana.weisdd.space - kibana.


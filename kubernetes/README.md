# Выпускной проект курса "DevOps практики и инструменты"
## Общая информация
Участники:
* [skushnerchuk](https://github.com/skushnerchuk)
* [4babushkin](https://github.com/4babushkin)
* [weisdd](https://github.com/weisdd)


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


### Ссылки на приложение и служебные сервисы
* http://nginx.weisdd.space - ui для бота;
* http://grafana.weisdd.space - grafana;
* http://prometheus-server.weisdd.space - prometheus.


Набор команд для запуска проекта:
```bash
cd terraform
terraform init
terraform apply
```
запуск Мониторинга (prometheus и grafana)
* prometheus - сервер сбора
* grafana - сервер визуализации метрик
```
cd ../kubernetes/
helm upgrade prometheus charts/prometheus/ --install
helm upgrade grafana charts/grafana/ --install
```
Запуск Логирования (elasticsearch, fluentd и kibana)
* ElasticSearch - база данных + поисковый движок
* Fluentd - шипер (отправитель) и агрегатор логов
* Kibana - веб-интерфейс для запросов в хранилище и отображения их результатов
```
helm dep update charts/efk
helm upgrade efk charts/efk/ --install
```
Запуск нашего приложения
```
helm dep update charts/crawler
helm upgrade crawler charts/crawler/ --install
```

### Ссылки на приложение и служебные сервисы
* http://nginx.weisdd.space - ui для бота;
* http://grafana.weisdd.space - grafana;
* http://prometheus-server.weisdd.space - prometheus.
* http://kibana.weisdd.space - kibana.


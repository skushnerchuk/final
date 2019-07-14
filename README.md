# Выпускной проект курса "DevOps практики и инструменты"
## Общая информация
Участники:
* [skushnerchuk](https://github.com/skushnerchuk)
* [4babushkin](https://github.com/4babushkin)
* [weisdd](https://github.com/weisdd)

Задачи проекта:
* автоматическое развертывание микросервисного приложения crawler ([backend](https://github.com/express42/search_engine_crawler), [frontend](https://github.com/express42/search_engine_ui));
* организация мониторинга, логгирования;
* выстраивание процессов CI/CD.

Использованные продукты и технологии:
* контейнеризация: Docker;
* оркестрация: GKE;
* provisioning: terraform (+ Terraform Cloud Remote State Management);
* СУБД: MongoDB;
* брокер сообщений: RabbitMQ;
* CI/CD: Gitlab CI.

## Запуск и остановка проекта
### Запуск
Note: Поскольку в проекте используется Terraform Cloud Remote State Management, перед первым запуском terraform необходимо получить токен на https://app.terraform.io/ и сохранить его в ~/.terraformrc:
```
credentials "app.terraform.io" {
    token = "mhVn15hHLylFvQ.atlasv1.jAH..."
}
```

Набор команд для запуска проекта:
```bash
cd terraform
terraform init
terraform apply
cd ../kubernetes/
kubectl apply -f tiller.yaml
helm init --service-account tiller
helm install stable/nginx-ingress --name nginx
helm upgrade prometheus charts/prometheus/ --install
helm upgrade grafana charts/grafana/ --install
helm dep update charts/crawler
helm upgrade crawler charts/crawler/ --install
kubectl get svc
```

### Ссылки на приложение и служебные сервисы
В настоящий момент нет функционала по автоматическому провижионингу DNS, поэтому после запуска приложения необходимо вручную запросить IP loadbalancer'а:
```bash
$ kubectl get svc
NAME                                  TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                        AGE
nginx-nginx-ingress-controller        LoadBalancer   10.23.242.78    35.190.211.102   80:30470/TCP,443:30056/TCP     63s
```
Затем зайти в https://console.cloud.google.com/net-services/dns/zones/crawler?project=docker-239201 и обновить DNS-запись для weisdd.space.

Ссылки:
* http://weisdd.space - ui для бота;
* http://grafana.weisdd.space - grafana;
* http://prometheus-server.weisdd.space - prometheus.

### Остановка проекта
```bash
terraform destroy
```

## Планы разработки и текущие ограничения
### Ограничения
* pipeline в Gitlab CI пока предусматривает только сборку образов, их тестирование и публикацию на Docker Hub.
### Планы
* реализация стека ELK/EFK;
* дальнейшая модификация pipeline для организации staging area с ручным review перед развертыванием приложения в production.

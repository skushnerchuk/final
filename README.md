## **Выпускной проект курса "DevOps практики и инструменты"**

Участники:
[skushnerchuk](https://github.com/skushnerchuk)
[4babushkin](https://github.com/4babushkin)
[weisdd](https://github.com/weisdd)

В качестве сервисов для построения процессов непрерывной интеграции и поставки использовалось рекомендованное приложение.

Для реализации задачи использовались:
* Google Cloud Platform как основная платформа.
* Google Kubernetes Engine как платформа для оркестрации работы компонентов приложения.
* Terraform как инструмент описания и развертывания инфраструктуры.
* [Terraform Cloud Remote State Management](https://www.hashicorp.com/blog/using-terraform-cloud-remote-state-management) для хранения файлов состояния terraform.
* Docker для сборки образов приложения.
* docker-compose для локального запуска приложения.
* MongoDB как основная база данных для хранения результатов работы приложения.
* RabbitMQ как менеджер очередей.
* Приватный GitLab-сервер для организации сборки образов приложений и размещения их в Docker Hub

### Запуск и остановка проекта
Для использования Terraform Cloud Remote State Management необходимо зарегистрироваться и получить соответствующий токен, который разместить в файле **~/.terraformrc**, имеющий вид:
```
credentials "app.terraform.io" {
    token = "mhVn15hHLylFvQ.atlasv1.jAH..."
}
```
Для запуска проекта необходимо выполнить в папке проекта последовательность команд:
```bash
cd terraform
terraform init
terraform apply
cd ../kubernetes/
kubectl apply -f tiller.yaml
helm init --service-account tiller
helm install stable/nginx-ingress --name nginx
helm dep update charts/crawler
helm install --name test charts/crawler
kubectl get svc
```
Остановка:
```bash
helm del test
helm del --purge test
helm delete nginx
```
### Планы разработки и текущие ограничения

* На данный момент не полностью реализован мониторинг состояния сервисов, а также уведомление об их состоянии.
* С помощью GitLab осуществляется пока только сборка образов, тестирование и их выгрузка в Docker Hub.
* Планируется добавление stage area для ручного тестирования перед развертыванием на боевом контуре, а также развертывание на боевом контуре в Kubernetes непосредственно из GitLab pipeline.

# Выпускной проект курса "DevOps практики и инструменты"
## Общая информация
Участники:
* Кушнерчук Сергей Юрьевич [skushnerchuk](https://github.com/skushnerchuk)
* Бабушкин Владимир Сергеевич [4babushkin](https://github.com/4babushkin)
* Беляков Игорь Вячеславович [weisdd](https://github.com/weisdd)

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
* CI/CD: Gitlab CI;
* логгирование: EFK.

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
cd ../deploy_scripts/
helm upgrade prometheus charts/prometheus/ --install
helm upgrade grafana charts/grafana/ --install
helm dep update charts/efk
helm upgrade efk charts/efk/ --install
helm dep update charts/rabbitmongo
helm upgrade rm charts/rabbitmongo --install
helm upgrade ui charts/ui --install --set mongodbHost=rm-mongodb
helm upgrade bot charts/bot --install --set mongodbHost=rm-mongodb --set rabbitmqHost=rm-rabbitmq
```
### Ссылки на приложение и служебные сервисы
* http://nginx.weisdd.space - production-ui для бота;
* http://grafana.weisdd.space - grafana;
* http://prometheus-server.weisdd.space - prometheus.

### Остановка проекта
```bash
cd terraform
terraform destroy
```

### Настройка GitLab для работы с развернутым кластером

После того, как кластер подготовлен к работе, необходимо настроить интеграцию проектов приложения с ним. Для этого следует в GitLab:

* перейти в раздел Operations/Kubernetes в проекте приложения
* нажать Add Kubernetes cluster, выбрать вкладку Existing Kebernetes cluster
* Задать параметры интеграции

*Cluster name* - имя кластера

*API URL* - ссылка на Kubernetes API. Для ее получения выполните команду:
```bash
kubectl cluster-info | grep 'Kubernetes master' | awk '/http/ {print $NF}'
```
и полученный адрес укажите в этом поле

*CA Certificate* - клиентский сертификат. Для его получения выполните команды:
```bash
kubectl get secrets
kubectl get secret default-token-xxxxx -o jsonpath="{['data']['ca\.crt']}" | base64 --decode
```
где default-token-xxxxx - имя секрета, выдаваемого первой командой.

*Service Token* - токен, используемый для доступа к кластеру. Для его получения необходимо:
* создайте файл *sa.yaml* с содержимым

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gitlab-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: gitlab-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: gitlab-admin
  namespace: kube-system
```
Примените этот манифест и получите токен:
```bash
kubectl apply -f sa.yaml
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep gitlab-admin | awk '{print $1}')
```

Поле **namespace** заполнять не нужно.

### Схема и принципы развертывания компонентов приложения

Мы исходим из предположения, что за каждый компонент приложения отвечает отдельная команда, а значит
развертывание компонентов должно проходить абсолютно независимо. При этом тестирование той или иной части приложения следует осуществлять в изолированных пространствах, где развернуто полное рабочее окружение (за исключением
части, отвечающий за мониторинг и логгирование - эти компоненты одни для всех пространств). Также в отдельный репозиторий были вынесены скрипты, с помощью которых осуществляется развертывание приложения - за него тоже может отвечать другая команда.

Общая схема выглядит следующим образом.

1. При коммите автоматически проводятся два первые этапа - тестирование и сборка образа, которому присваивается тег по имени ветки.
2. Вручную запускается этап review, при этом в кластере создается тестовое пространство, куда раворачиваются все компоненты приложения. Создаются DNS-записи, которые необходимы для доступа в контур по доменному имени.
3. После окончания тестирования производится остановка тестового пространства, с полным удалением развернутых в нем компонентов и созданных на предыдущем этапе записей DNS.
4. На основании протестированного образа формируется образ релиза, которому присваивается тег - версия приложения, которая указывается в файле VERSION в корне проекта.
5. Производится развертывание протестированного компонента на боевой контур.

При тестировании компонента поиска для формирования тестового окружения необходимо указать, какую версию образа веб-интерфейса надо использовать при тестировании, указав ее в файле VERSION_UI в корне проекта бота.

Для реализации процессов мы использовали приватный self-hosted экземпляр GitLab.

![](/screenshots/1.png)

![](/screenshots/2.png)

![](/screenshots/3.png)

### Подготовка проектов

Надо создать проекты:
* crawler - для бота;
* crawler_ui - для его интерфейса;
* deploy_scripts - для чартов разввертывания.

В скриптах сборки проектов **crawler** и **crawler_ui** следует изменить ссылку на репозиторий чартов в команде
```bash
git clone https://$CI_CREDENTIALS@gitlab.sk-developer.ru/otus/deploy-scripts.git charts
```
После отправки обновлений в репозиторий бота (или его UI) сборка и тестирование компонента
выполняется автоматически. Развертывание в review и production выполняется вручную из pipeline коммита.

Переменные, используемые в проекте, и которые должны быть указаны в свойствах проекта:

- **KUBE_INGRESS_BASE_DOMAIN** - базовый домен, на основании которого строятся ссылки на соответствующие пространства в Kubernetes (поле **Base domain** раздела **Operations -> Kubernetes** настроек проекта);
- **CI_REGISTRY_USER** - имя пользователя репозитария hub.docker.com;
- **CI_REGISTRY_PASSWORD** - пароль пользователя репозитария hub.docker.com;
- **CI_SERVICE_ACCOUNT** - ключ доступа сервисного аккаунта, который используется для доступа к кластеру, в формате строки, закодированной в base64. Для создания аккаунта необходимо в разделе **IAM & admin -> Service account** создать аккаунт с необходимыми правами, и создать для него ключ в формате JSON. Скачанный файл необходимо преобразовать в нужный формат командой:
```
cat <filename> | base64 -w 0
```
и получившуюся строку поместить в переменную **CI_SERVICE_ACCOUNT**
- **CI_CLUSTER_NAME** - имя кластера;
- **CI_CLUSTER_ZONE** - зона, в которой размещается кластер (например, europe-west1-b);
- **CI_GC_PROJECT** - идентификатор проекта в Google Cloud Platform (например, docker-123456);
- **CI_CREDENTIALS** - в нашем случае это реквизиты для авторизации при клонировании репозитария со скриптами развертывания.

Все тестируемые пространства отображаются в мониторинге без дополнительных действий:
![](/screenshots/monitoring.png)

Также был подготовлен образ, включающий в себя все необходимые компоненты для развертывания приложения (gcloud, kubectl, helm). Он  используется при развертывании приложения в кластере, и его использование (в отличие от установки зависимостей во время сборки) позволяет изменять версии используемых утилит без изменения сборочного скрипта.

## Здесь лежат скрипты и конфиги Kubernetes

Начал делать контроллеры для Kubernetes по образу и подобию как у нас было в ДЗ

Сделал

* `tiller.yaml` - Tiller - это аддон Kubernetes, т.е. Pod, который общается с API Kubernetes.
  Для этого понадобится ему выдать ServiceAccount и назначить роли RBAC, необходимые для работы. 
* `ui-deployment.yaml`, `ui-service.yaml` - контроллеры для ui
* `bot-deployment.yaml` -контроллер для bot
* `mongo-deployment.yaml`, `mongo-service.yaml` - контроллер для mongodb с Динамическим выделеним Volume'ов для хранения БД
* `mongo-claim-dynamic.yaml` `mongo-storage-fast.yml` - Динамическим выделеним Volume'ов для хранения БД
* для реббита пока не знаю как он работает

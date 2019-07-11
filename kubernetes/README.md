## Здесь лежат скрипты и конфиги Kubernetes

Configuration to provision the application onto Kubernetes.

Сделал контроллеры для Kubernetes

* `tiller.yaml` - Tiller - это аддон Kubernetes, т.е. Pod, который общается с API Kubernetes.
  Для этого понадобится ему выдать ServiceAccount и назначить роли RBAC, необходимые для работы. 
* `ui-deployment.yaml`, `ui-service.yaml` - контроллеры для ui
* `bot-deployment.yaml` -контроллер для bot
* `mongo-deployment.yaml`, `mongo-service.yaml` - контроллер для mongodb с Динамическим выделеним Volume'ов для хранения БД
* `mongo-claim-dynamic.yaml` `mongo-storage-fast.yml` - Динамическим выделеним Volume'ов для хранения БД
* `rabbit-service.yaml` `rabbit-deployment.yml` - rabbitmq

Сделаны helm чарты /kubernetes/charts 

запуск 
```
kubectl apply -f tiller.yaml
helm init --service-account tiller
```
Из Helm-чарта установим ingress-контроллер nginx
```
helm install stable/nginx-ingress --name nginx
```
Обновлим зависимости чарта приложение
```
helm dep update
```
Запускаем приложение
```
helm install --name test crawler/
NAME:   test
LAST DEPLOYED: Thu Jul 11 13:46:28 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/PersistentVolumeClaim
NAME          STATUS   VOLUME    CAPACITY  ACCESS MODES  STORAGECLASS  AGE
test-mongodb  Pending  standard  1s

==> v1/Pod(related)
NAME                            READY  STATUS             RESTARTS  AGE
test-bot-6795b9fbbc-dhhms       0/1    ContainerCreating  0         1s
test-mongodb-856757b684-78n7s   0/1    Pending            0         1s
test-rabbitmq-594757f5c5-wgdp6  0/1    ContainerCreating  0         1s
test-ui-66dbc49c9-v7qbm         0/1    ContainerCreating  0         1s

==> v1/Secret
NAME          TYPE    DATA  AGE
test-mongodb  Opaque  2     1s

==> v1/Service
NAME           TYPE       CLUSTER-IP     EXTERNAL-IP  PORT(S)                       AGE
test-bot       ClusterIP  10.39.248.155  <none>       8000/TCP                      1s
test-mongodb   ClusterIP  10.39.246.31   <none>       27017/TCP                     1s
test-rabbitmq  ClusterIP  10.39.251.90   <none>       5672/TCP,25672/TCP,15672/TCP  1s
test-ui        NodePort   10.39.246.231  <none>       8000:31288/TCP                1s

==> v1beta1/Deployment
NAME          READY  UP-TO-DATE  AVAILABLE  AGE
test-mongodb  0/1    1           0          1s

==> v1beta1/Ingress
NAME     HOSTS  ADDRESS  PORTS  AGE
test-ui  test            80     1s

==> v1beta2/Deployment
NAME           READY  UP-TO-DATE  AVAILABLE  AGE
test-bot       0/1    1           0          1s
test-rabbitmq  0/1    1           0          1s
test-ui        0/1    1           0          1s
```
узнаем ip
```
kubectl get svc
NAME                                  TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                        AGE
kubernetes                            ClusterIP      10.39.240.1     <none>          443/TCP                        63m
nginx-nginx-ingress-controller        LoadBalancer   10.39.241.118   35.187.125.93   80:32260/TCP,443:30733/TCP     7m1s
nginx-nginx-ingress-default-backend   ClusterIP      10.39.243.80    <none>          80/TCP                         7m
test-bot                              ClusterIP      10.39.240.135   <none>          8000/TCP                       38m
test-mongodb                          ClusterIP      10.39.244.235   <none>          27017/TCP                      38m
test-rabbitmq                         ClusterIP      10.39.254.159   <none>          5672/TCP,25672/TCP,15672/TCP   38m
test-ui                               NodePort       10.39.248.99    <none>          8000:30892/TCP                 38m
```
заходим по адресу  http://35.187.125.93

удалить
```
helm del test
helm del --purge test
helm delete nginx
```



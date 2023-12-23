## Задача 1

Дайте письменые ответы на вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm-кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm-кластере?
- Что такое Overlay Network?

### Ответ:

- В случае, когда указан mode global, сервис запускается на всех нодах.  mode replication - только на тех нодах, которые мы указали в конфиге.
- RAFT - алгоритм построен на распределенном консенсусе, то есть в единицу времени, как минимум две ноды участвуют, отправляют заявку на лидерство, тот кто первый ответил, то становится лидером. Дальше в работе ноды между собой посылают запросы, чтобы определить доступен ли лидер и отвечает ли он до сих пор самый первый, в случае, когда лидер не ответил в заданное время идет пересогласование по тому же принципу
- Overlay Network - распределенная сеть кластера, которая позволяет общаться контейнерам между собой на разных нодах, возможно шифрование трафика. docker engine в рамках такой сети, сам занимается маршрутизацией.
## Задача 2

Создайте ваш первый Docker Swarm-кластер в Яндекс Облаке.

```
[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
0egjomipw7uoihrstf665512c *   node01.netology.yc   Ready     Active         Leader           24.0.7
voa9su14af8btj3vnje8u3uq7     node02.netology.yc   Ready     Active         Reachable        24.0.7
uob0kzzsqlkobc54ra4h7v38t     node03.netology.yc   Ready     Active         Reachable        24.0.7
jwi5vo4x4l4xhfoiggxsh2cg0     node04.netology.yc   Ready     Active                          24.0.7
d3hsuv6gvc8bkiaqess14m8r7     node05.netology.yc   Ready     Active                          24.0.7
mjj74oajqgk2hzx8p0bbsbcfi     node06.netology.yc   Ready     Active                          24.0.7

```

## Задача 3

Создайте ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

```
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
kilc4alm3879   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
u4ioql5s5gdb   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
fiyw00h3dg3q   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
v71ujcpja91f   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
qq13h1q27ru6   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
bemo1u3jx5vh   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
44y6h3avbdji   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
3xvghy7zs3xk   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```

## Задача 4 (*)

Выполните на лидере Docker Swarm-кластера команду, указанную ниже, и дайте письменное описание её функционала — что она делает и зачем нужна:
```
[root@node01 ~]# docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-ZOuI6yQmokg7nYu4qPk5XhjgUIZvOPRYi2TyiU1goko

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.

```
### Ответ
Команда шифрует конфигурацию докер сворма. При перезапуске необходимо будет "разлочить" сворм ключом выше с помощью команды **docker swarm unlock**.



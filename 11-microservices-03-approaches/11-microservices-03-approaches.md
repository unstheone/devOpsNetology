# Домашнее задание к занятию «Микросервисы: подходы»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.


## Задача 1: Обеспечить разработку

Предложите решение для обеспечения процесса разработки: хранение исходного кода, непрерывная интеграция и непрерывная поставка. 
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- облачная система;
- система контроля версий Git;
- репозиторий на каждый сервис;
- запуск сборки по событию из системы контроля версий;
- запуск сборки по кнопке с указанием параметров;
- возможность привязать настройки к каждой сборке;
- возможность создания шаблонов для различных конфигураций сборок;
- возможность безопасного хранения секретных данных (пароли, ключи доступа);
- несколько конфигураций для сборки из одного репозитория;
- кастомные шаги при сборке;
- собственные докер-образы для сборки проектов;
- возможность развернуть агентов сборки на собственных серверах;
- возможность параллельного запуска нескольких сборок;
- возможность параллельного запуска тестов.

Обоснуйте свой выбор.
 ____

## Решение 1
Под требования указанные в описании подходит GitLab. Удобный в управлении и использовании, огромное комьюнити. 

- облачная система - GitLab можно использовать в нативном облаке или же развернуть в Yandex\Google\Amazon;
- система контроля версий Git - присутствует;
- репозиторий на каждый сервис - количество репозиториев неограниченно;
- запуск сборки по событию из системы контроля версий - Запуск пайплайна возможен по событию в VCS (commit, tag creation, итд.);
- запуск сборки по кнопке с указанием параметров - запуск пайплайнов вручную также возможен;
- возможность привязать настройки к каждой сборке - если речь о переменных значениях, возможно указать их с привязкой к пайплайну;
- возможность создания шаблонов для различных конфигураций сборок - GitLab поддерживает создание шаблонов;
- возможность безопасного хранения секретных данных (пароли, ключи доступа) - встроенной возможности нет, поэтому предлагается использовать интеграцию с HashiCorp Vault;
- несколько конфигураций для сборки из одного репозитория - GitLab позволяет создавать различные пайплайны для одного репозитория;
- кастомные шаги при сборке - В GitLab пайплайне можно прописывать кастомные stages;
- собственные докер-образы для сборки проектов - GitLab позволяет использовать любые образы при конфигурации docker-раннера;
- возможность развернуть агентов сборки на собственных серверах - docker-раннер можно запускать на физических и облачных серверах);
- возможность параллельного запуска нескольких сборок - неограниченный параллельный запуск пайплайнов;
- возможность параллельного запуска тестов - неограниченный параллельный запуск тестов.
## Задача 2: Логи

Предложите решение для обеспечения сбора и анализа логов сервисов в микросервисной архитектуре.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- сбор логов в центральное хранилище со всех хостов, обслуживающих систему;
- минимальные требования к приложениям, сбор логов из stdout;
- гарантированная доставка логов до центрального хранилища;
- обеспечение поиска и фильтрации по записям логов;
- обеспечение пользовательского интерфейса с возможностью предоставления доступа разработчикам для поиска по записям логов;
- возможность дать ссылку на сохранённый поиск по записям логов.

Обоснуйте свой выбор.
_____
## Решение 2
ELK (ElasticSearch + LogStash + Kibana)
ELK имеет широкое распространение, следовательно, найти инженеров не должно быть сложно. Много документации, информации и примеров на github. Имеется облачный вариант с поддержкой вендора.

| Требование                                                                                                               | Функционал Elastic Stack |
|--------------------------------------------------------------------------------------------------------------------------|--------------------------|
| Сбор логов в центральное хранилище со всех хостов, обслуживающих систему                                                 | Данные хранятся централизованно в одной или нескольких локациях | 
| Минимальные требования к приложениям, сбор логов из stdout                                                               | LogStash имеет плагин для сбора логов из stdout |
| Гарантированная доставка логов до центрального хранилища                                                                 | LogStash имеет защиту от потерь данных при ненормальном завершении процесса |
| Обеспечение поиска и фильтрации по записям логов                                                                         | ElasticSearch это поисковая система, основаная на библиотеке Apache Lucene |
| Обеспечение пользовательского интерфейса с возможностью предоставления доступа разработчикам для поиска по записям логов | Kibana обеспечивает пользовательский интерфейс для поиска и поддерживает язык запросов KQL | 
| Возможность дать ссылку на сохранённый поиск по записям логов                                                            | KQL поддерживает ссылки на сохранённые запросы |


## Задача 3: Мониторинг

Предложите решение для обеспечения сбора и анализа состояния хостов и сервисов в микросервисной архитектуре.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- сбор метрик со всех хостов, обслуживающих систему;
- сбор метрик состояния ресурсов хостов: CPU, RAM, HDD, Network;
- сбор метрик потребляемых ресурсов для каждого сервиса: CPU, RAM, HDD, Network;
- сбор метрик, специфичных для каждого сервиса;
- пользовательский интерфейс с возможностью делать запросы и агрегировать информацию;
- пользовательский интерфейс с возможностью настраивать различные панели для отслеживания состояния системы.

Обоснуйте свой выбор.

_____
## Решение 3

Лучшими на мой взгляд будет Prometheus + Grafana

- Высокая производительность при низком потреблении ресурсов
- Документация и распространенность решения, отличное комьюнити
- Grafana обладает отличным функционалом визуализации

| Требование                                                                                                | Функционал Prometheus + Grafana                                                                                                                                  |
|-----------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Сбор метрик со всех хостов, обслуживающих систему                                                         | Поддерживается, количество мониторируемых хостов неограниченно                                                                                                   |
| Сбор метрик состояния ресурсов хостов: CPU, RAM, HDD, Network                                             | Поддерживается node_exporter                                                                                                                                     |
| Сбор метрик потребляемых ресурсов для каждого сервиса: CPU, RAM, HDD, Network                             | Поддерживается, много уже реализованных экспортеров                                                                                                              |
| Сбор метрик, специфичных для каждого сервиса                                                              | Поддерживается, если не нашелся существующий экспортер - можно написать свой                                                                                     |
| Пользовательский интерфейс с возможностью делать запросы и агрегировать информацию                        | Поддерживается язык запросов PromQL (Prometheus Query Language) для выборки и агрегации метрик                                                                   |
| Пользовательский интерфейс с возможностью настраивать различные панели для отслеживания состояния системы | Имеются дашборды под любые задачи, можно создавать собственные. Grafana предоставляет средства визуализации и дополнительного анализа информации из Prometheus.  |

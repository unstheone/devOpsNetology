<br>tested on Ubuntu 20.04, but can be adopted for other distributions
<br>*don't forget to enter your host IP address in ``vars.yml``*
---

[site.yml](site.yml) содержит 2 блока: Clickhouse & Vector

## Clickhouse
### Объединяет последовательность задач по инсталяции Clickhouse. Блоку соответствует ```tags: clickhouse```
#### Параметры по умолчанию
- ```clickhouse_version: "22.4.6.53"``` - версия Clickhouse
- ```clickhouse_packages: ["clickhouse-client", "clickhouse-server", "clickhouse-common-static"]``` - список пакетов для установки

#### Последовательность Task'ов:
- ```[Clickhouse. Get clickhouse distrib]``` - скачивает deb-пакеты с дистрибутивами с помощью модуля ```ansible.builtin.get_url```
- ```[Clickhouse. Install clickhouse packages]``` - устанавливает набор пакетов с помощью модуля ```ansible.builtin.apt```
- ```[Clickhouse. Flush handlers]``` - инициирует внеочередной запуск хандлера ```Start clickhouse service```
- ```RUNNING HANDLER [Start clickhouse service]``` - для старта сервера ```clickhouse``` в хандлере используется модуль ```ansible.builtin.service```
- ```[Clickhouse. Wait for clickhouse-server to become available]``` - устанавливает паузу в 15 секунд с помощью модуля ```ansible.builtin.pause```, чтобы сервер Clickhouse успел запуститься.
- ```[Clickhouse. Create database]``` - создает инстанс базы данных Clickhouse

## Vector
### Объединяет последовательность задач по инсталяции Vector. Блоку соответствует ```tags: vector```
#### Параметры по умолчанию
- ```vector_version: "0.21.1"``` - версия Vector
- ```vector_os_arh: "x86_64"``` - архитектура ОС
- ```vector_workdir: "/home/ubuntu/vector"``` - рабочий каталог, в котором будут сохранены скачанные rpm-пакеты
- ```vector_os_user: "vector"``` - имя пользователя-владельца Vector в ОС
- ```vector_os_group: "vector"``` - имя группы пользователя-владельца Vector в ОС

#### Последовательность Task'ов:
- ```[Vector. Create work directory]``` - создает рабочий каталог, в котором будут сохранены скачанные deb-пакеты, с помощью модуля ```ansible.builtin.file```
- ```[Vector. Get Vector distributive]``` - скачивает архив с дистрибутивом с помощью модуля ```ansible.builtin.get_url```
- ```[Vector. Unzip archive]``` - распаковывает скачанный архив с помощью модуля ```ansible.builtin.unarchive```
- ```[Vector. Install vector binary file]``` - копирует исполняемый файл Vector в ```/usr/bin``` с помощью модуля ```ansible.builtin.copy```
- ```[Vector. Check Vector installation]``` - проверяет, что бинарный файл Vector работает корректно, с помощью модуля ```ansible.builtin.command```
- ```[Vector. Create Vector config vector.toml]``` - создает файл ```/etc/vector/vector.toml``` с конфигом Vector с помощью модуля ```ansible.builtin.copy```
- ```[Vector. Create vector.service daemon]``` - создает файл юнита systemd ```/lib/systemd/system/vector.service``` с помощью модуля ```ansible.builtin.copy```
- ```[Vector. Modify vector.service file]``` - редактирует файл юнита systemd ```/lib/systemd/system/vector.service``` с помощью модуля ```ansible.builtin.replace```
- ```[Vector. Create user vector]``` - создает пользователя ОС с помощью модуля ```ansible.builtin.user```
- ```[Vector. Create data_dir]``` - создает каталог для данных Vector с помощью модуля ```ansible.builtin.file```
- ```RUNNING HANDLER [Start Vector service]``` - инициируется запуск хандлера ```Start Vector service```, обновляющего конфигурацию systemd и стартующего сервис ```vector.service``` с помощью модуля ```ansible.builtin.systemd```
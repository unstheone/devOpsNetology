# Домашнее задание к занятию 3 «Использование Ansible»

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
#### Done
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
#### В [site.yml](playbook%2Fsite.yml) добавлен PLAY с tags=lighthouse, устанавливающий и настраивающий lighthouse.
4. Подготовьте свой inventory-файл `prod.yml`.
#### Done [prod.yml](playbook%2Finventory%2Fprod.yml)
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
#### Без ошибок
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
<details>
    <summary>
        ansible-playbook --check -i ../playbook/inventory/prod.yml  ../playbook/site.yml
    </summary>
        
        
        PLAY [Install Clickhouse] ****************************************************************************************************************************************************************************
        
        TASK [Get clickhouse distrib] ************************************************************************************************************************************************************************
        The authenticity of host '158.160.116.255 (158.160.116.255)' can't be established.
        ED25519 key fingerprint is SHA256:2PlilH/aaFt6BUtMoS4Lqr7PnC8BTIyWVCyW1GqYR70.
        This key is not known by any other names
        Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
        changed: [clickhouse-01] => (item=clickhouse-client)
        changed: [clickhouse-01] => (item=clickhouse-server)
        failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.4.3.3.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.4.3.3.noarch.rpm"}
        
        TASK [Get clickhouse distrib] ************************************************************************************************************************************************************************
        changed: [clickhouse-01] => (item=clickhouse-client)
        changed: [clickhouse-01] => (item=clickhouse-server)
        changed: [clickhouse-01] => (item=clickhouse-common-static)
        
        TASK [Install clickhouse packages] *******************************************************************************************************************************************************************
        fatal: [clickhouse-01]: FAILED! => {"ansible_facts": {"pkg_mgr": "yum"}, "changed": false, "msg": "No RPM file matching 'clickhouse-common-static-22.4.3.3.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-common-static-22.4.3.3.rpm' found on system"]}
        
        PLAY RECAP *******************************************************************************************************************************************************************************************
        clickhouse-01              : ok=1    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   


</details>

#### Обрывается на отсутсвующих пакетах
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

<details>
    <summary>
        ansible-playbook --diff -i ../playbook/inventory/prod.yml  ../playbook/site.yml
    </summary>

```commandline
PLAY [Install Clickhouse] ****************************************************************************************************************************************************************************

TASK [Get clickhouse distrib] ************************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.4.3.3.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.4.3.3.noarch.rpm"}

TASK [Get clickhouse distrib] ************************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
ok: [clickhouse-01] => (item=clickhouse-common-static)

TASK [Install clickhouse packages] *******************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Modify Clickhouse config.xml] ******************************************************************************************************************************************************************
--- before: /etc/clickhouse-server/config.xml
+++ after: /etc/clickhouse-server/config.xml
@@ -180,7 +180,7 @@
 
 
     <!-- Same for hosts without support for IPv6: -->
-    <!-- <listen_host>0.0.0.0</listen_host> -->
+    <listen_host>0.0.0.0</listen_host>
 
     <!-- Default values - try listen localhost on IPv4 and IPv6. -->
     <!--

changed: [clickhouse-01]

TASK [Flush handlers] ********************************************************************************************************************************************************************************

RUNNING HANDLER [Start clickhouse service] ***********************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Wait for clickhouse-server to become available] ************************************************************************************************************************************************
Pausing for 30 seconds (output is hidden)
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [clickhouse-01]

TASK [Create database] *******************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create Clickhouse table] ***********************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Vector] ****************************************************************************************************************************************************************************************

TASK [Create vector work directory] ******************************************************************************************************************************************************************
The authenticity of host '51.250.86.234 (51.250.86.234)' can't be established.
ED25519 key fingerprint is SHA256:71G8gfSSUDPynfztRPFi1T3ifYGffl7oPc60KUHs3lo.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
--- before
+++ after
@@ -1,5 +1,5 @@
 {
-    "mode": "0775",
+    "mode": "0755",
     "path": "/home/centos/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01]

TASK [Get Vector distrib] ****************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Unzip Vector archive] **************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Install Vector binary] *************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Check Vector installation] *********************************************************************************************************************************************************************
changed: [vector-01]

TASK [Create Vector etc directory] *******************************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/etc/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01]

TASK [Create Vector config vector.yaml] **************************************************************************************************************************************************************
--- before
+++ after: /home/uns/.ansible/tmp/ansible-local-25838k736mbxw/tmpth_kteev/vector.yaml.j2
@@ -0,0 +1,26 @@
+---
+data_dir: /var/lib/vector
+
+# Random Syslog-formatted logs
+sources:
+  dummy_logs:
+    type: demo_logs
+    format: syslog
+    interval: 1
+
+
+# Save parsed logs to Clickhouse
+sinks:
+  clickhouse_logs:
+    type: clickhouse
+    inputs:
+      - dummy_logs
+    database: logs
+    endpoint: http://clickhouse-01:8123
+    table: logs_table
+    acknowledgements:
+      enabled: false
+    healthcheck:
+      enabled: false
+    compression: gzip
+    skip_unknown_fields: true
\ No newline at end of file

changed: [vector-01]

TASK [Create vector.service daemon] ******************************************************************************************************************************************************************
changed: [vector-01]

TASK [Modify Vector.service file ExecStart] **********************************************************************************************************************************************************
--- before: /lib/systemd/system/vector.service
+++ after: /lib/systemd/system/vector.service
@@ -7,7 +7,7 @@
 [Service]
 User=vector
 Group=vector
-ExecStartPre=/usr/bin/vector validate
+ExecStartPre=/usr/bin/vector validate --config-yaml /etc/vector/vector.yaml
 ExecStart=/usr/bin/vector
 ExecReload=/usr/bin/vector validate
 ExecReload=/bin/kill -HUP $MAINPID

changed: [vector-01]

TASK [Modify Vector.service file ExecStartPre] *******************************************************************************************************************************************************
--- before: /lib/systemd/system/vector.service
+++ after: /lib/systemd/system/vector.service
@@ -8,7 +8,7 @@
 User=vector
 Group=vector
 ExecStartPre=/usr/bin/vector validate --config-yaml /etc/vector/vector.yaml
-ExecStart=/usr/bin/vector
+ExecStart=/usr/bin/vector --config-yaml /etc/vector/vector.yaml
 ExecReload=/usr/bin/vector validate
 ExecReload=/bin/kill -HUP $MAINPID
 Restart=no

changed: [vector-01]

TASK [Create user vector] ****************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Create Vector data_dir] ************************************************************************************************************************************************************************
--- before
+++ after
@@ -1,6 +1,6 @@
 {
-    "group": 0,
-    "owner": 0,
+    "group": 1001,
+    "owner": 1001,
     "path": "/var/lib/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01]

RUNNING HANDLER [Start Vector service] ***************************************************************************************************************************************************************
changed: [vector-01]

PLAY [Lighthouse] ************************************************************************************************************************************************************************************

TASK [Pre-install epel-release] **********************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Pre-install Nginx & Git client] ****************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Clone Lighthouse source code by Git] ***********************************************************************************************************************************************************
>> Newly checked out d701335c25cd1bb9b5155711190bad8ab852c2ce
changed: [lighthouse-01]

TASK [Prepare nginx config] **************************************************************************************************************************************************************************
--- before
+++ after: /home/uns/.ansible/tmp/ansible-local-26225nl79x7xe/tmpb5w8zjyz/lighthouse.conf.j2
@@ -0,0 +1,12 @@
+server {
+    listen 8080;
+    server_name 0.0.0.0;
+
+    access_log /var/log/nginx/lighthouse-access.log;
+
+    location / {
+        root /home/user/lighthouse/;
+        index index.html;
+
+    }
+}
\ No newline at end of file

changed: [lighthouse-01]

RUNNING HANDLER [Start Lighthouse service] ***********************************************************************************************************************************************************
changed: [lighthouse-01]

PLAY RECAP *******************************************************************************************************************************************************************************************
clickhouse-01              : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=5    changed=5    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=13   changed=13   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

</details>

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

<details>
    <summary>
        ansible-playbook --diff -i ../playbook/inventory/prod.yml  ../playbook/site.yml
    </summary>

```commandline
PLAY [Install Clickhouse] ****************************************************************************************************************************************************************************

TASK [Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.4.3.3.rpm", "elapsed": 0, "gid": 1000, "group": "centos", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "centos", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 251643818, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.4.3.3.noarch.rpm"}

TASK [Get clickhouse distrib] ************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
ok: [clickhouse-01] => (item=clickhouse-common-static)

TASK [Install clickhouse packages] *******************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Modify Clickhouse config.xml] ******************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] ********************************************************************************************************************************************************************************

TASK [Wait for clickhouse-server to become available] ************************************************************************************************************************************************
Pausing for 30 seconds (output is hidden)
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [clickhouse-01]

TASK [Create database] *******************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create Clickhouse table] ***********************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Vector] ****************************************************************************************************************************************************************************************

TASK [Create vector work directory] ******************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get Vector distrib] ****************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Unzip Vector archive] **************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install Vector binary] *************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Check Vector installation] *********************************************************************************************************************************************************************
changed: [vector-01]

TASK [Create Vector etc directory] *******************************************************************************************************************************************************************
ok: [vector-01]

TASK [Create Vector config vector.yaml] **************************************************************************************************************************************************************
ok: [vector-01]

TASK [Create vector.service daemon] ******************************************************************************************************************************************************************
changed: [vector-01]

TASK [Modify Vector.service file ExecStart] **********************************************************************************************************************************************************
--- before: /lib/systemd/system/vector.service
+++ after: /lib/systemd/system/vector.service
@@ -7,7 +7,7 @@
 [Service]
 User=vector
 Group=vector
-ExecStartPre=/usr/bin/vector validate
+ExecStartPre=/usr/bin/vector validate --config-yaml /etc/vector/vector.yaml
 ExecStart=/usr/bin/vector
 ExecReload=/usr/bin/vector validate
 ExecReload=/bin/kill -HUP $MAINPID

changed: [vector-01]

TASK [Modify Vector.service file ExecStartPre] *******************************************************************************************************************************************************
--- before: /lib/systemd/system/vector.service
+++ after: /lib/systemd/system/vector.service
@@ -8,7 +8,7 @@
 User=vector
 Group=vector
 ExecStartPre=/usr/bin/vector validate --config-yaml /etc/vector/vector.yaml
-ExecStart=/usr/bin/vector
+ExecStart=/usr/bin/vector --config-yaml /etc/vector/vector.yaml
 ExecReload=/usr/bin/vector validate
 ExecReload=/bin/kill -HUP $MAINPID
 Restart=no

changed: [vector-01]

TASK [Create user vector] ****************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Create Vector data_dir] ************************************************************************************************************************************************************************
ok: [vector-01]

RUNNING HANDLER [Start Vector service] ***************************************************************************************************************************************************************
changed: [vector-01]

PLAY [Lighthouse] ************************************************************************************************************************************************************************************

TASK [Pre-install epel-release] **********************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Pre-install Nginx & Git client] ****************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Clone Lighthouse source code by Git] ***********************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Prepare nginx config] **************************************************************************************************************************************************************************
ok: [lighthouse-01]

PLAY RECAP *******************************************************************************************************************************************************************************************
clickhouse-01              : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=13   changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

</details>

![img1.png](img%2Fimg1.png)
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
#### [README.md](playbook%2FREADME.md)
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.
#### Done
---


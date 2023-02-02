### На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:
      sudo ln -s ~/node_exporter-1.5.0.linux-386/node_exporter /usr/sbin - сделал симлинк, чтобы в конфиге сервиса потом использовать
      vi /etc/systemd/system/node_exporter.service - создал конфиг файл для сервиса с таким контентом:
         [Unit]
         Description=Node Exporter
         
         [Service]
         ExecStart=/usr/sbin/node_exporter -f $EXTRA_OPTS
         Restart=Always
         
         [Install]
         WantedBy=default.target

* поместите его в автозагрузку:
  *     vagrant@vagrant:~$ sudo systemctl enable node_exporter 
        vagrant@vagrant:~$ sudo systemctl is-enabled node_exporter.service
           enabled
* предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`)
  *     vagrant@vagrant:~$ NE_OPTS="log.format=json"
        [Service]
        ExecStart=/usr/sbin/node_exporter $NE_OPTS
        vagrant@vagrant:~$ systemctl daemon-reload
        vagrant@vagrant:~$ systemctl stop node_exporter
        vagrant@vagrant:~$ systemctl start node_exporter
* удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
  *     vagrant@vagrant:~$ uptime
        12:03:55 up 0 min,  1 user,  load average: 0.66, 0.20, 0.07
        vagrant@vagrant:~$ systemctl status node_exporter
        node_exporter.service - Node Exporter
        Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
        Active: active (running) since Thu 2023-01-26 11:57:17 UTC; 2s ago
        Main PID: 31105 (node_exporter)
         Tasks: 7 (limit: 1065)
         Memory: 2.2M
         CGroup: /system.slice/node_exporter.service
                └─31105 /usr/sbin/node_exporter

      

### Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
        vagrant@vagrant:~$ curl http://127.0.0.1:9100/metrics | less
            Интересные:
            
            node_arp_entries{device="eth0"} 2
            node_cpu_seconds_total{cpu="0",mode="idle"} 8420.99
            node_cpu_seconds_total*
            node_filesystem_avail_bytes
            node_memory_MemAvailable_bytes
            node_memory_MemFree_bytes
            node_memory_MemTotal_bytes
            node_memory_Mlocked_bytes
            node_memory_SwapFree_bytes
            node_memory_SwapTotal_bytes
            node_netstat_Tcp_ActiveOpens
            node_netstat_Tcp_CurrEstab
            node_netstat_Tcp_InErrs
            node_network_carrier_changes_total{device="eth0"}
            node_network_info
            node_network_receive_bytes_total
            node_network_receive_drop_total
            node_network_receive_errs_total
            node_network_up
            node_os_version
            

### Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). 
   
* После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

  После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
  *     default: Forwarding ports...
        default: 19999 (guest) => 19999 (host) (adapter 1)
    
### Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
        vagrant@vagrant:~$ dmesg | grep virtual
        [    0.003758] CPU MTRRs all blank - virtualized system.
        [    0.106102] Booting paravirtualized kernel on KVM
        [    2.647614] systemd[1]: Detected virtualization oracle.    
### Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Определите, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?
        vagrant@vagrant:~$ sysctl -a | grep fs.nr
        sysctl: fs.nr_open = 1048576
        
        параметр определяет максимальное число открытых дескрипторов
        
        vagrant@vagrant:~$ ulimit -n
        1024

        на пользователя ограничение в 1024 открытых дескрипторов
### Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.
        vagrant@vagrant:~$ sudo -i
        root@vagrant:~# unshare --fork --pid --mount-proc sleep 1h
        ^Z
        [1]+  Stopped                 unshare --fork --pid --mount-proc sleep 1h
        root@vagrant:~# bg 1
        [1]+ unshare --fork --pid --mount-proc sleep 1h &
        root@vagrant:~# ps -aux | grep sleep
        root        1857  0.0  0.0   5480   516 pts/0    S    05:46   0:00 unshare --fork --pid --mount-proc sleep 1h
        root        1858  0.0  0.0   5476   516 pts/0    S    05:46   0:00 sleep 1h
        root        1860  0.0  0.0   6432   720 pts/0    S+   05:47   0:00 grep --color=auto sleep
        root@vagrant:~# nsenter --target 1858 --pid --mount
        root@vagrant:/# ps
            PID TTY          TIME CMD
              1 pts/0    00:00:00 sleep
              2 pts/0    00:00:00 bash
             13 pts/0    00:00:00 ps
        root@vagrant:~# exit
        logout
        vagrant@vagrant:~$ ps
            PID TTY          TIME CMD
           1727 pts/0    00:00:00 bash
           1831 pts/0    00:00:00 bash
           1875 pts/0    00:00:00 ps
        vagrant@vagrant:~$ sudo lsns | grep sleep
        4026532192 mnt         2  1857 root            unshare --fork --pid --mount-proc sleep 1h
        4026532193 pid         1  1858 root            sleep 1h
### Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации.  
        :(){ :|:& };: - это бэш функция, рекурсивно вызывающая сама себя. В более понятном виде можно представить так:
        
        fu {
            fu | fu &
        }; fu
        
        fu вызывает сама себя и свой stdout выдаёт снова на себя. Это происходит, предельное количество процессов, которое может создать пользователь.
        Далее в дело вступает pids controller.
        vagrant@vagrant:~$ dmesg
        [ 2137.616886] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope
- Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
  -     pid controller ограничивает число процессов, которые юзер может создать в юзерспейсе.
        изменить можно командой ulimit -u {value}
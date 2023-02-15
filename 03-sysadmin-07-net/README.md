1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
```
vagrant@vagrant:~$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:59:cb:31 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 86333sec preferred_lft 86333sec
    inet6 fe80::a00:27ff:fe59:cb31/64 scope link
       valid_lft forever preferred_lft forever
```
`в Windows ipconfig /all, в линукс ip addr или ifconfig`
2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
`используется LLDP`
```
vagrant@vagrant:~$ sudo apt install lldpd
vagrant@vagrant:~$ sudo systemctl enable lldpd && systemctl start lldpd
vagrant@vagrant:~$ sudo systemctl status lldpd
● lldpd.service - LLDP daemon
     Loaded: loaded (/lib/systemd/system/lldpd.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2023-02-14 13:55:10 UTC; 1min 2s ago
       Docs: man:lldpd(8)
   Main PID: 30217 (lldpd)
      Tasks: 2 (limit: 1065)
     Memory: 1.8M
     CGroup: /system.slice/lldpd.service
             ├─30217 lldpd: monitor.
             └─30230 lldpd: no neighbor.
vagrant@vagrant:~$ lldpctl
-------------------------------------------------------------------------------
LLDP neighbors:
-------------------------------------------------------------------------------
```

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

```
Технология - VLAN
Команда для установки пакета - apt install vlan
Чтобы включить тегирование, необходимо создать саб интерфейс и повесить на него адрес, после чего рестартануть интерфейс:

vi /etc/network/interfaces

        auto vlan1400
        iface vlan1400 inet static
         address 192.168.1.1
         netmask 255.255.255.0
         vlan_raw_device eth0
         
ip link set dev eth0 down
ip link set dev eth0 up
```

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
```
Типы аггрегации - Teaming и bonding.
Режимы балансировки следующие:
    0 - balance-rr - (round-robin)
    1 - active-backup
    2 - balance-xor
    3 - broadcast
    4 - 802.3ad - (dynamic link aggregation)
    5 - balance-tlb - (adaptive transmit load balancing)
    6 - balance-alb - (adaptive load balancing)
Для установки пакета:
    apt-get install ifenslave
Пример конфига аггрегации eth0 и eth1:
    vagrant@vagrant:~$ cat /etc/network/interfaces
    # interfaces(5) file used by ifup(8) and ifdown(8)
    # Include files from /etc/network/interfaces.d:
    source-directory /etc/network/interfaces.d
    auto eth0
    iface eth0 inet manual
        bond-master bond0
        bond-primary eth0
        bond-mode active-backup
    auto eth1
    iface eth1 inet manual
        bond-master bond0
        bond-primary eth0
        bond-mode active-backup
    auto bond0
    iface bond0 inet dhcp
        bond-slaves none
        bond-primary eth0
        bond-mode active-backup
        bond-miimon 100
    vagrant@vagrant:~$ sudo ifup bond0
    Waiting for bonding kernel module to be ready (will timeout after 5s)
    Waiting for a slave to join bond0 (will timeout after 60s)
    No slave joined bond0, continuing anyway
    Internet Systems Consortium DHCP Client 4.4.1
    Copyright 2004-2018 Internet Systems Consortium.
    All rights reserved.
    For info, please visit https://www.isc.org/software/dhcp/
    
    Listening on LPF/bond0/ce:16:92:37:a0:49
    Sending on   LPF/bond0/ce:16:92:37:a0:49
    Sending on   Socket/fallback
    

```
5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
`в префиксе /29 имеется 8 IP адресов, из них 6 доступно для назначения хостам, 1 - адрес сети, 1 - бродкаст. Из одной /24 сети можно получить 32 сети /29. Я считаю обычно так - из старшего префикса (/29) вычитаю младший (/24), получаю число (5). Это число использую как степень двойк (2 в 5 степени).
Раскладка сети 10.10.10.0/24 на /29-ые подсети следующая:
`
```
10.10.10.0/29
10.10.10.8/29
10.10.10.16/29
10.10.10.24/29
10.10.10.32/29
...
10.10.10.216/29
10.10.10.224/29
10.10.10.232/29
10.10.10.240/29
10.10.10.248/29
```
6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
```
Можно взять из пространства 100.64.0.0/10. Если нужно 50 хостов внутри, то маску необходимо взять не меньше /26 (64 адреса, из них 62 для хостов). Маска /27 содержит уже 32 адреса, поэтому нам не подходит.
```
7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
```
Для Windows:
    arp -a - вывести всю таблицу
    arp -d {inet_addr} - удалить запись для конкретного IP адреса
    arp -d * - удалить все записи
Для Linux работает arp как для Windows. Ещё есть ip:
    ip neigh - вывести всю таблицу
    ip neigh { add | del | change | replace } - добавить/удалить/поменять
    ip neigh flush - удалить все записи 
```

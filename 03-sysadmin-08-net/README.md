## Задание

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
route-views>sho ip route 213.33.102.22
Routing entry for 213.33.0.0/17, supernet
  Known via "bgp 6447", distance 20, metric 0
  Tag 3356, type external
  Last update from 4.68.4.46 4w3d ago
  Routing Descriptor Blocks:
  * 4.68.4.46, from 4.68.4.46, 4w3d ago
      Route metric is 0, traffic share count is 1
      AS Hops 2
      Route tag 3356
      MPLS label: none
      
route-views>show bgp 213.33.168.0
BGP routing table entry for 213.33.128.0/17, version 2638479604
Paths: (20 available, best #17, table default)
  Not advertised to any peer
  Refresh Epoch 1
  8283 3216
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3216:2001 3216:2999 3216:4100 8283:1 8283:101 65000:52254 65000:65049
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x24
        value 0000 205B 0000 0000 0000 0001 0000 205B
              0000 0005 0000 0001 0000 205B 0000 0008
              0000 0040
      path 7FE11D2D0650 RPKI State not found
      rx pathid: 0, tx pathid: 0
```
2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
```
vagrant@vagrant:~$ sudo su
root@vagrant:/home/vagrant# echo "dummy" >> /etc/modules
root@vagrant:/home/vagrant# echo "options dummy numdummies=2" > /etc/modprobe.d/dummy.conf
root@vagrant:/home/vagrant# vim /etc/network/interfaces
root@vagrant:/home/vagrant# cat /etc/network/interfaces
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
    auto dummy0
    iface dummy0 inet static
    address 10.2.2.2/32
    pre-up ip link add dummy0 type dummy
    post-down ip link del dummy0
root@vagrant:/home/vagrant# exit
vagrant@vagrant:~$ sudo ifup dummy0
vagrant@vagrant:~$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:59:cb:31 brd ff:ff:ff:ff:ff:ff
3: bond0: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/ether ce:16:92:37:a0:49 brd ff:ff:ff:ff:ff:ff
4: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether e6:cc:4f:75:6e:f5 brd ff:ff:ff:ff:ff:ff
vagrant@vagrant:~$ sudo ip ro add 5.5.5.5/32 via 10.2.2.2
vagrant@vagrant:~$ sudo ip ro add 6.6.6.6/32 via 10.2.2.2
vagrant@vagrant:~$ ip ro
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
5.5.5.5 via 10.2.2.2 dev dummy0
6.6.6.6 via 10.2.2.2 dev dummy0
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
```
3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
```
ssh и dns серверы:
    vagrant@vagrant:~$ ss -ltnp
    State                    Recv-Q                   Send-Q                                     Local Address:Port                                      Peer Address:Port                   Process
    LISTEN                   0                        4096                                       127.0.0.53%lo:53                                             0.0.0.0:*
    LISTEN                   0                        128                                              0.0.0.0:22                                             0.0.0.0:*
```
4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
```
bootp (DHCP) и dns:
    vagrant@vagrant:~$ ss -au
    State                    Recv-Q                   Send-Q                                      Local Address:Port                                       Peer Address:Port                  Process
    UNCONN                   0                        0                                           127.0.0.53%lo:domain                                          0.0.0.0:*
    UNCONN                   0                        0                                          10.0.2.15%eth0:bootpc                                          0.0.0.0:*
```
5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 
`приложил скриншот`

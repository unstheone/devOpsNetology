
## Задание

### Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах. 
        sparce файлы вместо хранения последовательности нулевых байтов хранят только информацию об этих последовательностях
### Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
        не могут, они наследуют права доступа от файла, на который ссылаются. Меняешь на линке или на файле - меняется везде
### Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:
        done
#### Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
      vagrant@sysadm-fs:~$ sudo fdisk /dev/sdb

      Welcome to fdisk (util-linux 2.34).
      Changes will remain in memory only, until you decide to write them.
      Be careful before using the write command.
      
      Device does not contain a recognized partition table.
      Created a new DOS disklabel with disk identifier 0xf066389c.
      
      Command (m for help): m
      
      Help:
      
        DOS (MBR)
         a   toggle a bootable flag
         b   edit nested BSD disklabel
         c   toggle the dos compatibility flag
      
        Generic
         d   delete a partition
         F   list free unpartitioned space
         l   list known partition types
         n   add a new partition
         p   print the partition table
         t   change a partition type
         v   verify the partition table
         i   print information about a partition
      
        Misc
         m   print this menu
         u   change display/entry units
         x   extra functionality (experts only)
      
        Script
         I   load disk layout from sfdisk script file
         O   dump disk layout to sfdisk script file
      
        Save & Exit
         w   write table to disk and exit
         q   quit without saving changes
      
        Create a new label
         g   create a new empty GPT partition table
         G   create a new empty SGI (IRIX) partition table
         o   create a new empty DOS partition table
         s   create a new empty Sun partition table
      
      
      Command (m for help): n
      Partition type
         p   primary (0 primary, 0 extended, 4 free)
         e   extended (container for logical partitions)
      Select (default p): p
      Partition number (1-4, default 1): 1
      First sector (2048-5242879, default 2048): 2048
      Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2GB
      
      Created a new partition 1 of type 'Linux' and of size 1.9 GiB.
      
      Command (m for help): n
      Partition type
         p   primary (1 primary, 0 extended, 3 free)
         e   extended (container for logical partitions)
      Select (default p): p
      Partition number (2-4, default 2): 2
      First sector (3907584-5242879, default 3907584): 3907584
      Last sector, +/-sectors or +/-size{K,M,G,T,P} (3907584-5242879, default 5242879): 5242879
      
      Created a new partition 2 of type 'Linux' and of size 652 MiB.
      
      vagrant@sysadm-fs:~$ sudo fdisk -l /dev/sdb
      Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
      Disk model: VBOX HARDDISK
      Units: sectors of 1 * 512 = 512 bytes
      Sector size (logical/physical): 512 bytes / 512 bytes
      I/O size (minimum/optimal): 512 bytes / 512 bytes
      Disklabel type: dos
      Disk identifier: 0xf066389c
      
      Device     Boot   Start     End Sectors  Size Id Type
      /dev/sdb1          2048 3907583 3905536  1.9G 83 Linux
      /dev/sdb2       3907584 5242879 1335296  652M 83 Linux
#### Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.
      vagrant@sysadm-fs:~$ sudo sfdisk -d /dev/sdb | sudo sfdisk --force /dev/sdc
      Checking that no-one is using this disk right now ... OK
      
      Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
      Disk model: VBOX HARDDISK
      Units: sectors of 1 * 512 = 512 bytes
      Sector size (logical/physical): 512 bytes / 512 bytes
      I/O size (minimum/optimal): 512 bytes / 512 bytes
      
      >>> Script header accepted.
      >>> Script header accepted.
      >>> Script header accepted.
      >>> Script header accepted.
      >>> Created a new DOS disklabel with disk identifier 0xf066389c.
      /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 1.9 GiB.
      /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 652 MiB.
      /dev/sdc3: Done.
      
      New situation:
      Disklabel type: dos
      Disk identifier: 0xf066389c
      
      Device     Boot   Start     End Sectors  Size Id Type
      /dev/sdc1          2048 3907583 3905536  1.9G 83 Linux
      /dev/sdc2       3907584 5242879 1335296  652M 83 Linux
      
      The partition table has been altered.
      Calling ioctl() to re-read partition table.
      Syncing disks.
#### Соберите `mdadm` RAID1 на паре разделов 2 Гб.
      vagrant@sysadm-fs:~$ sudo mdadm --create --verbose /dev/md1 -l 1 -n 2 -N big_raid /dev/sdb1 /dev/sdc1
      mdadm: Note: this array has metadata at the start and
          may not be suitable as a boot device.  If you plan to
          store '/boot' on this device please ensure that
          your boot-loader understands md/v1.x metadata, or use
          --metadata=0.90
      mdadm: size set to 1950720K
      Continue creating array?
      Continue creating array? (y/n) y
      mdadm: Defaulting to version 1.2 metadata
      mdadm: array /dev/md1 started.
      vagrant@sysadm-fs:~$ cat /proc/mdstat
      Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
      md1 : active raid1 sdc1[1] sdb1[0]
            1950720 blocks super 1.2 [2/2] [UU]
            [================>....]  resync = 84.6% (1652096/1950720) finish=0.0min speed=206512K/sec
#### Соберите `mdadm` RAID0 на второй паре маленьких разделов.
      vagrant@sysadm-fs:~$ sudo mdadm --create --verbose /dev/md2 -l 0 -n 2 -N small_raid /dev/sdb2 /dev/sdc2
      mdadm: chunk size defaults to 512K
      mdadm: Defaulting to version 1.2 metadata
      mdadm: array /dev/md2 started.
      vagrant@sysadm-fs:~$ cat /proc/mdstat
      Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
      md2 : active raid0 sdc2[1] sdb2[0]
            1331200 blocks super 1.2 512k chunks
         
      md1 : active raid1 sdc1[1] sdb1[0]
            1950720 blocks super 1.2 [2/2] [UU]
      vagrant@sysadm-fs:~$ lsblk | grep sd
      sda                         8:0    0   64G  0 disk
      ├─sda1                      8:1    0    1M  0 part
      ├─sda2                      8:2    0    2G  0 part  /boot
      └─sda3                      8:3    0   62G  0 part
      sdb                         8:16   0  2.5G  0 disk
      ├─sdb1                      8:17   0  1.9G  0 part
      └─sdb2                      8:18   0  652M  0 part
      sdc                         8:32   0  2.5G  0 disk
      ├─sdc1                      8:33   0  1.9G  0 part
      └─sdc2                      8:34   0  652M  0 part
#### Создайте 2 независимых PV на получившихся md-устройствах.
      vagrant@sysadm-fs:~$ sudo pvcreate /dev/md1
        Physical volume "/dev/md1" successfully created.
      vagrant@sysadm-fs:~$ sudo pvcreate /dev/md2
        Physical volume "/dev/md2" successfully created.
      vagrant@sysadm-fs:~$ sudo pvs
        PV         VG        Fmt  Attr PSize   PFree
        /dev/md1             lvm2 ---    1.86g  1.86g
        /dev/md2             lvm2 ---   <1.27g <1.27g
        /dev/sda3  ubuntu-vg lvm2 a--  <62.00g 31.00g
#### Создайте общую volume-group на этих двух PV.
      vagrant@sysadm-fs:~$ sudo vgcreate VG /dev/md1 /dev/md2
        Volume group "VG" successfully created
      vagrant@sysadm-fs:~$ sudo vgs
        VG        #PV #LV #SN Attr   VSize   VFree
        VG          2   0   0 wz--n-   3.12g  3.12g
        ubuntu-vg   1   1   0 wz--n- <62.00g 31.00g
#### Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
      vagrant@sysadm-fs:~$ sudo lvcreate -L 100M VG /dev/md2
        Logical volume "lvol0" created.
      vagrant@sysadm-fs:~$ lsblk
      NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
      loop0                       7:0    0   62M  1 loop  /snap/core20/1611
      loop2                       7:2    0 67.8M  1 loop  /snap/lxd/22753
      loop3                       7:3    0 49.8M  1 loop  /snap/snapd/17950
      loop4                       7:4    0 63.3M  1 loop  /snap/core20/1778
      loop5                       7:5    0 91.9M  1 loop  /snap/lxd/24061
      sda                         8:0    0   64G  0 disk
      ├─sda1                      8:1    0    1M  0 part
      ├─sda2                      8:2    0    2G  0 part  /boot
      └─sda3                      8:3    0   62G  0 part
        └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm   /
      sdb                         8:16   0  2.5G  0 disk
      ├─sdb1                      8:17   0  1.9G  0 part
      │ └─md1                     9:1    0  1.9G  0 raid1
      └─sdb2                      8:18   0  652M  0 part
        └─md2                     9:2    0  1.3G  0 raid0
          └─VG-lvol0            253:1    0  100M  0 lvm
      sdc                         8:32   0  2.5G  0 disk
      ├─sdc1                      8:33   0  1.9G  0 part
      │ └─md1                     9:1    0  1.9G  0 raid1
      └─sdc2                      8:34   0  652M  0 part
        └─md2                     9:2    0  1.3G  0 raid0
          └─VG-lvol0            253:1    0  100M  0 lvm
#### Создайте `mkfs.ext4` ФС на получившемся LV.
      vagrant@sysadm-fs:~$ sudo mkfs.ext4 /dev/VG/lvol0
      mke2fs 1.45.5 (07-Jan-2020)
      Found a sgi partition table in /dev/VG/lvol0
      Proceed anyway? (y,N) y
      Creating filesystem with 25600 4k blocks and 25600 inodes
      
      Allocating group tables: done
      Writing inode tables: done
      Creating journal (1024 blocks): done
      Writing superblocks and filesystem accounting information: done

      vagrant@sysadm-fs:~$ sudo parted /dev/VG/lvol0
      GNU Parted 3.3
      Using /dev/dm-1
      Welcome to GNU Parted! Type 'help' to view a list of commands.
      (parted) print
      Model: Linux device-mapper (linear) (dm)
      Disk /dev/dm-1: 105MB
      Sector size (logical/physical): 512B/512B
      Partition Table: loop
      Disk Flags:
      
      Number  Start  End    Size   File system  Flags
       1      0.00B  105MB  105MB  ext4
#### Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
      vagrant@sysadm-fs:~$ mkdir /tmp/new
      vagrant@sysadm-fs:~$ mount /dev/VG/lvol0 /tmp new
      vagrant@sysadm-fs:~$ df -hT | grep ext4
      /dev/mapper/ubuntu--vg-ubuntu--lv ext4       31G  3.7G   26G  13% /
      /dev/sda2                         ext4      2.0G  106M  1.7G   6% /boot
      /dev/mapper/VG-lvol0              ext4       93M   24K   86M   1% /tmp/new
#### Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
      vagrant@sysadm-fs:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
      --2023-02-09 12:35:34--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
      Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
      Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
      HTTP request sent, awaiting response... 200 OK
      Length: 24691519 (24M) [application/octet-stream]
      Saving to: ‘/tmp/new/test.gz’
      
      /tmp/new/test.gz                                     100%[=====================================================================================================================>]  23.55M  2.09MB/s    in 8.9s
      
      2023-02-09 12:35:44 (2.64 MB/s) - ‘/tmp/new/test.gz’ saved [24691519/24691519]
#### Прикрепите вывод `lsblk`.
      vagrant@sysadm-fs:~$ lsblk
      NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
      loop0                       7:0    0   62M  1 loop  /snap/core20/1611
      loop2                       7:2    0 67.8M  1 loop  /snap/lxd/22753
      loop3                       7:3    0 49.8M  1 loop  /snap/snapd/17950
      loop4                       7:4    0 63.3M  1 loop  /snap/core20/1778
      loop5                       7:5    0 91.9M  1 loop  /snap/lxd/24061
      sda                         8:0    0   64G  0 disk
      ├─sda1                      8:1    0    1M  0 part
      ├─sda2                      8:2    0    2G  0 part  /boot
      └─sda3                      8:3    0   62G  0 part
        └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm   /
      sdb                         8:16   0  2.5G  0 disk
      ├─sdb1                      8:17   0  1.9G  0 part
      │ └─md1                     9:1    0  1.9G  0 raid1
      └─sdb2                      8:18   0  652M  0 part
        └─md2                     9:2    0  1.3G  0 raid0
          └─VG-lvol0            253:1    0  100M  0 lvm   /tmp/new
      sdc                         8:32   0  2.5G  0 disk
      ├─sdc1                      8:33   0  1.9G  0 part
      │ └─md1                     9:1    0  1.9G  0 raid1
      └─sdc2                      8:34   0  652M  0 part
        └─md2                     9:2    0  1.3G  0 raid0
          └─VG-lvol0            253:1    0  100M  0 lvm   /tmp/new

#### Протестируйте целостность файла:
      vagrant@sysadm-fs:~$ gzip -t /tmp/new/test.gz
      vagrant@sysadm-fs:~$ echo $?
      0

#### Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
      vagrant@sysadm-fs:~$ sudo pvmove /dev/md2 /dev/md1
        /dev/md2: Moved: 16.00%
        /dev/md2: Moved: 100.00%
      vagrant@sysadm-fs:~$ lsblk
      NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
      loop0                       7:0    0   62M  1 loop  /snap/core20/1611
      loop2                       7:2    0 67.8M  1 loop  /snap/lxd/22753
      loop3                       7:3    0 49.8M  1 loop  /snap/snapd/17950
      loop4                       7:4    0 63.3M  1 loop  /snap/core20/1778
      loop5                       7:5    0 91.9M  1 loop  /snap/lxd/24061
      sda                         8:0    0   64G  0 disk
      ├─sda1                      8:1    0    1M  0 part
      ├─sda2                      8:2    0    2G  0 part  /boot
      └─sda3                      8:3    0   62G  0 part
        └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm   /
      sdb                         8:16   0  2.5G  0 disk
      ├─sdb1                      8:17   0  1.9G  0 part
      │ └─md1                     9:1    0  1.9G  0 raid1
      │   └─VG-lvol0            253:1    0  100M  0 lvm   /tmp/new
      └─sdb2                      8:18   0  652M  0 part
        └─md2                     9:2    0  1.3G  0 raid0
      sdc                         8:32   0  2.5G  0 disk
      ├─sdc1                      8:33   0  1.9G  0 part
      │ └─md1                     9:1    0  1.9G  0 raid1
      │   └─VG-lvol0            253:1    0  100M  0 lvm   /tmp/new
      └─sdc2                      8:34   0  652M  0 part
        └─md2                     9:2    0  1.3G  0 raid0
#### Сделайте `--fail` на устройство в вашем RAID1 md.
      vagrant@sysadm-fs:~$ sudo mdadm --manage --fail /dev/md1 /dev/sdb1
      mdadm: set /dev/sdb1 faulty in /dev/md1
#### Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
      [10217.860884] md/raid1:md1: Disk failure on sdb1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
#### Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
      vagrant@sysadm-fs:~$ gzip -t /tmp/new/test.gz
      vagrant@sysadm-fs:~$ echo $?
      0

#### Погасите тестовый хост, `vagrant destroy`.
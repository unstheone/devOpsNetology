### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Консоль управления Yandex Cloud](https://console.cloud.yandex.ru/folders/<cloud_id>/vpc/security-groups).
2. [Группы безопасности](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav).
3. [Datasource compute disk](https://terraform-eap.website.yandexcloud.net/docs/providers/yandex/d/datasource_compute_disk.html).

### Задание 1

1. Изучите проект. ``done``
2. Заполните файл personal.auto.tfvars. ``done``
3. Инициализируйте проект, выполните код. Он выполнится, даже если доступа к preview нет. ``done``

Примечание. Если у вас не активирован preview-доступ к функционалу «Группы безопасности» в Yandex Cloud, запросите доступ у поддержки облачного провайдера. Обычно его выдают в течение 24-х часов.

Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud или скриншот отказа в предоставлении доступа к preview-версии.

![sec-groups.png](img%2Fsec-groups.png)

------

### Задание 2

1. Создайте файл count-vm.tf. Опишите в нём создание двух **одинаковых** ВМ  web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, используя мета-аргумент **count loop**. Назначьте ВМ созданную в первом задании группу безопасности.(как это сделать узнайте в документации провайдера yandex/compute_instance )

```terraform
resource "yandex_compute_instance" "web" {
  count = 2
  name        = "${var.learning_platform}-${var.vpc_name}-${var.vpc_platform}-${var.vm_role["web"]}-${count.index+1}"
  platform_id = var.vm_platform_id
  resources {
    cores         = var.vms_resources["cores"]
    memory        = var.vms_resources["ram"]
    core_fraction = var.vms_resources["c_f"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  metadata = {
    serial-port-enable = var.vm_metadata["serial-port-enable"]
    ssh-keys           = var.vm_metadata["ssh-keys"]
  }
}
```
2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ для баз данных с именами "main" и "replica" **разных** по cpu/ram/disk , используя мета-аргумент **for_each loop**. Используйте для обеих ВМ одну общую переменную типа:
```
variable "each_vm" {
  type = list(object({  vm_name=string, cpu=number, ram=number, disk=number }))
}
```  
При желании внесите в переменную все возможные параметры.
```terraform
resource "yandex_compute_instance" "db" {
  for_each = {
    primary = "main"
    secondary = "replica"
  }
    name        = "${var.learning_platform}-${var.vpc_name}-${var.vpc_platform}-${var.vm_role["db"]}-${each.value}"
    platform_id = var.vm_platform_id
  resources {
    cores = var.vms_resources2[each.key]["cpu"]
    memory = var.vms_resources2[each.key]["ram"]
    #disk = var.vms_resources2[each.key]["disk"] с дисками непонимаю, как быть
    core_fraction = var.vms_resources2[each.key]["c_f"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
### ... и так далее
  
```
![task2.png](img%2Ftask2.png)
3. ВМ из пункта 2.1 должны создаваться после создания ВМ из пункта 2.2.
```terraform
### добавил depends_on
resource "yandex_compute_instance" "web" {
  depends_on = [yandex_compute_instance.db]
```
4. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.
```terraform
#### создаем в locals.tf
locals {
  ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
}
#### передаём в count-vm.tf && for_each-vm.tf
  metadata = {
    serial-port-enable = var.vm_metadata["serial-port-enable"]
    ssh-keys           = local.ssh-keys
```
5. Инициализируйте проект, выполните код.

```terraform
Plan: 7 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_vpc_network.develop: Creating...
yandex_vpc_network.develop: Creation complete after 3s [id=enpplcm1f8s35heg3sef]
yandex_vpc_subnet.develop: Creating...
yandex_vpc_security_group.example: Creating...
yandex_vpc_subnet.develop: Creation complete after 0s [id=e9boj2mvpf8ai49lq03k]
yandex_compute_instance.db["secondary"]: Creating...
yandex_compute_instance.db["primary"]: Creating...
yandex_vpc_security_group.example: Creation complete after 1s [id=enp0g99qp3bv5td8msqj]
yandex_compute_instance.db["primary"]: Still creating... [10s elapsed]
yandex_compute_instance.db["secondary"]: Still creating... [10s elapsed]
yandex_compute_instance.db["secondary"]: Still creating... [20s elapsed]
yandex_compute_instance.db["primary"]: Still creating... [20s elapsed]
yandex_compute_instance.db["primary"]: Still creating... [31s elapsed]
yandex_compute_instance.db["secondary"]: Still creating... [31s elapsed]
yandex_compute_instance.db["primary"]: Creation complete after 36s [id=fhmug9ks5dqh1312r6v3]
yandex_compute_instance.db["secondary"]: Creation complete after 39s [id=fhmblq3jdvhhgudvk8ju]
yandex_compute_instance.web[1]: Creating...
yandex_compute_instance.web[0]: Creating...
yandex_compute_instance.web[0]: Still creating... [10s elapsed]
yandex_compute_instance.web[1]: Still creating... [10s elapsed]
yandex_compute_instance.web[0]: Still creating... [20s elapsed]
yandex_compute_instance.web[1]: Still creating... [20s elapsed]
yandex_compute_instance.web[1]: Creation complete after 30s [id=fhm5p78926odue221g07]
yandex_compute_instance.web[0]: Still creating... [30s elapsed]
yandex_compute_instance.web[0]: Still creating... [40s elapsed]
yandex_compute_instance.web[0]: Creation complete after 45s [id=fhmrmsdin037au91v800]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

```

------

### Задание 3

1. Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf** .
```terraform
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_disk.one-GB-disk[0] will be created
  + resource "yandex_compute_disk" "one-GB-disk" {
      + block_size  = 4096
      + created_at  = (known after apply)
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + product_ids = (known after apply)
      + size        = 1
      + status      = (known after apply)
      + type        = "network-ssd"
      + zone        = (known after apply)
    }

  # yandex_compute_disk.one-GB-disk[1] will be created
  + resource "yandex_compute_disk" "one-GB-disk" {
      + block_size  = 4096
      + created_at  = (known after apply)
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + product_ids = (known after apply)
      + size        = 1
      + status      = (known after apply)
      + type        = "network-ssd"
      + zone        = (known after apply)
    }

  # yandex_compute_disk.one-GB-disk[2] will be created
  + resource "yandex_compute_disk" "one-GB-disk" {
      + block_size  = 4096
      + created_at  = (known after apply)
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + product_ids = (known after apply)
      + size        = 1
      + status      = (known after apply)
      + type        = "network-ssd"
      + zone        = (known after apply)
    }

```
2. Создайте в том же файле **одиночную**(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage"  . Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.
```terraform
resource "yandex_compute_instance" "storage" {
  depends_on = [yandex_compute_disk.one-GB-disk]
  name = "${var.learning_platform}-${var.vpc_name}-${var.vpc_platform}-${var.vm_role["storage"]}"
  platform_id = var.vm_platform_id
  resources {
    cores         = var.vms_resources["cores"]
    memory        = var.vms_resources["ram"]
    core_fraction = var.vms_resources["c_f"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  dynamic "secondary_disk" {
    for_each = "${yandex_compute_disk.one-GB-disk.*.id}"
    content {
      disk_id = yandex_compute_disk.one-GB-disk["${secondary_disk.key}"].id
    }
  }
  network_interface {
        subnet_id = yandex_vpc_subnet.develop.id
        nat     = true
  }
  metadata = {
        ssh-keys = local.ssh-keys
  }
}
```
------

### Задание 4

1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demonstration2).
Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.
2. Инвентарь должен содержать 3 группы и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.
3. Добавьте в инвентарь переменную  [**fqdn**](https://cloud.yandex.ru/docs/compute/concepts/network#hostname).
4. Выполните код. Приложите скриншот получившегося файла. 

```tf
[webservers]

%{~ for i in webservers ~}
%{ if "${i["network_interface"][0]["nat"]}" != false }
${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]}   fqdn=${i["id"]}.auto.internal
%{ else }
${i["name"]}   ansible_host=${i["network_interface"][0]["ip_address"]}   fqdn=${i["id"]}.auto.internal
%{ endif}
%{~ endfor ~}

[databases]

%{~ for i in db_instance ~}
%{ if "${i["network_interface"][0]["nat"]}" != false }
${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]}   fqdn=${i["id"]}.auto.internal
%{ else }
${i["name"]}   ansible_host=${i["network_interface"][0]["ip_address"]}   fqdn=${i["id"]}.auto.internal
%{ endif}
%{~ endfor ~}

[storage]

%{~ for i in storage_instance ~}
%{ if "${i["network_interface"][0]["nat"]}" != false }
${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]}   fqdn=${i["id"]}.auto.internal
%{ else }
${i["name"]}   ansible_host=${i["network_interface"][0]["ip_address"]}   fqdn=${i["id"]}.auto.internal
%{ endif}
%{~ endfor ~}
```
```commandline
[webservers]

netology-develop-platform-web-1   ansible_host=51.250.74.101   fqdn=fhmgkm77laeu2i08q888.auto.internal

netology-develop-platform-web-2   ansible_host=51.250.8.198   fqdn=fhm6efld9rft297b8ate.auto.internal

[databases]

netology-develop-platform-db-main   ansible_host=51.250.89.110   fqdn=fhmppfo57g5m4pshes6h.auto.internal

netology-develop-platform-db-replica   ansible_host=51.250.68.194   fqdn=fhm4ndif25m1a9sf1t06.auto.internal

[storage]

netology-develop-platform-storage   ansible_host=51.250.69.107   fqdn=fhm3pmvjum21026qimvd.auto.internal

```
![task4.png](img%2Ftask4.png)
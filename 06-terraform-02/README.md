
### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav). 
Этот функционал понадобится к следующей лекции.
``done``


### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.  Убедитесь что ваша версия **Terraform** =1.5.Х (версия 1.6.Х может вызывать проблемы с Яндекс провайдером) 

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider. ``done``
2. Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные: идентификаторы облака, токен доступа. Благодаря .gitignore этот файл не попадёт в публичный репозиторий. ``done`` \
   **Необязательное задание\*:** попробуйте самостоятельно разобраться с документацией и использовать авторизацию terraform provider с помощью [service_account_key_file](https://terraform-provider.yandexcloud.net).\
   Настройка провайдера при этом будет выглядеть следующим образом:
```
provider "yandex" {
  service_account_key_file = file("~/.authorized_key.json")
  folder_id                = var.folder_id
  cloud_id                 = var.cloud_id
}
```

``done``

3. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**. ``done``
4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
```terraform
yandex_compute_instance.platform: Creating...
╷
│ Error: Error while requesting API to create instance: server-request-id = ... rpc error: code = FailedPrecondition desc = Platform "standart-v4" not found
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
```
#### FIX - вместо ``platform_id = "standart-v4"`` делаем или ``platform_id = "standard-v3"``, или ``platform_id = "standard-v3-t4"``. Подроднее [здесь](https://cloud.yandex.ru/ru/docs/compute/concepts/vm-platforms) 
```terraform
│ Error: Error while requesting API to create instance: server-request-id = ... rpc error: code = InvalidArgument desc = the specified core fraction is not available on platform "standard-v3"; allowed core fractions: 20, 50, 100
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
```
#### FIX - вместо `core_fraction = 5` поставил `core_fraction = 20`
```terraform
 Error: Error while requesting API to create instance: server-request-id = ... rpc error: code = InvalidArgument desc = the specified number of cores is not available on platform "standard-v3"; allowed core number: 2, 4
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
```
#### FIX - добавил ядро - `cores         = 2`
#### после этого завелось:
```terraform
 Enter a value: yes

yandex_compute_instance.platform: Creating...
yandex_compute_instance.platform: Still creating... [10s elapsed]
yandex_compute_instance.platform: Still creating... [20s elapsed]
yandex_compute_instance.platform: Still creating... [30s elapsed]
yandex_compute_instance.platform: Still creating... [40s elapsed]
yandex_compute_instance.platform: Creation complete after 40s []id=fhmiat1ok5cbdqk1er8b]
```
5. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
```commandline
$ ssh ubuntu@158.160.121.238
The authenticity of host '158.160.121.238 (158.160.121.238)' can't be established.
ED25519 key fingerprint is SHA256:Xy9ACpOzL4vDkxvW9YRn8n7Ar8L7FDzIg/1KSWvhO5w.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '158.160.121.238' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-169-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@fhmiat1ok5cbdqk1er8b:~$ curl ifconfig.me
158.160.121.238
```
6. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.
#### ```preemptible = true``` - прерываемые машины дешевле, в процессе обучения поможет сэкономить квоту облака.
#### ```core_fraction = 5``` - снижаем долю ядер vCPU от вычислительного времени физических ядер, также помогает экономить.
В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
#### ![06-02-vm.png](img%2F06-02-vm.png) 
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
#### ![06-02-cli.png](img%2F06-02-cli.png)
- ответы на вопросы.
#### добавлены по тексту


### Задание 2

1. Изучите файлы проекта.
2. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 

#### Done. Изменения в [main.tf](src%2Fmain.tf) и [variables.tf](src%2Fvariables.tf). Plan в моём случае дал изменения, т.к. я уже сделал дестрой после первого задания (экономия).

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').
3. Примените изменения.

#### Done. Ниже фрагмент применения ``terraform apply``
```terraform
yandex_vpc_network.develop: Creating...
yandex_vpc_network.develop: Creation complete after 3s [id=enpivv1fi2kfjdllmijp]
yandex_vpc_subnet.develop: Creating...
yandex_vpc_subnet.develop: Creation complete after 1s [id=e9b00sns80poc7u0ic00]
yandex_compute_instance.platform: Creating...
yandex_compute_instance.platform-db: Creating...
yandex_compute_instance.platform: Still creating... [10s elapsed]
yandex_compute_instance.platform-db: Still creating... [10s elapsed]
yandex_compute_instance.platform-db: Still creating... [20s elapsed]
yandex_compute_instance.platform: Still creating... [20s elapsed]
yandex_compute_instance.platform-db: Still creating... [30s elapsed]
yandex_compute_instance.platform: Still creating... [30s elapsed]
yandex_compute_instance.platform: Creation complete after 33s [id=fhmmnu9o6k04e7gkla4o]
yandex_compute_instance.platform-db: Creation complete after 36s [id=fhmb2ejn625qthosg7pr]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

```

### Задание 4

1. Объявите в файле outputs.tf **один** output типа **map**, содержащий { instance_name = external_ip } для каждой из ВМ.
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.

```terraform
$ terraform output
vm_db_external_IP = {
  "external_ip" = "158.160.50.101"
  "instance_name" = "netology-develop-platform-db"
}
vm_web_external_IP = {
  "external_ip" = "158.160.110.244"
  "instance_name" = "netology-develop-platform-web"

```

### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с несколькими переменными по примеру из лекции.
2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local-переменные.
3. Примените изменения.

#### Применилось без изменения в инфраструктуру:

```terraform
$ terraform apply
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enpivv1fi2kfjdllmijp]
data.yandex_compute_image.ubuntu-db: Reading...
data.yandex_compute_image.ubuntu-db: Read complete after 1s [id=fd8k54g2t50mekbk1ie1]
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd8k54g2t50mekbk1ie1]
yandex_vpc_subnet.develop: Refreshing state... [id=e9b00sns80poc7u0ic00]
yandex_compute_instance.platform: Refreshing state... [id=fhmmnu9o6k04e7gkla4o]
yandex_compute_instance.platform-db: Refreshing state... [id=fhmb2ejn625qthosg7pr]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

vm_db_external_IP = {
  "external_ip" = "158.160.50.101"
  "instance_name" = "netology-develop-platform-db"
}
vm_web_external_IP = {
  "external_ip" = "158.160.110.244"
  "instance_name" = "netology-develop-platform-web"
}

```
#### locals.tf :
```terraform
locals {
  vm_name_local = "${var.learning_platform}-${var.vpc_name}-${var.vpc_platform}"
}
```
#### Изменения в main.tf :
```terraform
resource "yandex_compute_instance" "platform" {
  name        = "${local.vm_name_local}-${var.vm_role["web"]}"
   
   ...
   
resource "yandex_compute_instance" "platform-db" {
  name        = "${local.vm_name_local}-${var.vm_role["db"]}"
```
### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map.  
#### Я сделал общий мэп ресурсов для обоих ВМ, тк мне все равно не дает создать с разным core_fraction, то не стал плодить переменные
#### Изменения в variables.tf

```terraform
variable "vms_resources" {
  type        = map(number)
  default     = {
    cores     = 2
    ram       = 2
    c_f       = 20
  }
}
```
#### Изменения в main.tf

```terraform
   resources {
    cores         = var.vms_resources["cores"]
    memory        = var.vms_resources["ram"]
    core_fraction = var.vms_resources["c_f"]
   
```
2. Создайте и используйте отдельную map переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  
  
3. Найдите и закоментируйте все, более не используемые переменные проекта. ``done``
4. Проверьте terraform plan. Изменений быть не должно.
```terraform
$ terraform plan
data.yandex_compute_image.ubuntu-db: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enpjj3ve0m3fte1tq9q3]
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd8k54g2t50mekbk1ie1]
yandex_vpc_subnet.develop: Refreshing state... [id=e9b4mom0v7su8ubuu5or]
yandex_compute_instance.platform: Refreshing state... [id=fhm6rail9ocim1av44di]
yandex_compute_instance.platform-db: Refreshing state... [id=fhmc5adb9edr4t8lbs5u]
data.yandex_compute_image.ubuntu-db: Read complete after 2s [id=fd8k54g2t50mekbk1ie1]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

```
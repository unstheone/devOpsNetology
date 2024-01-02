###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

### Naming variables ###

variable "learning_platform" {
  type        = string
  default     = "netology"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC name"
}
variable "vpc_platform" {
  type        = string
  default     = "platform"
  description = "VPC platform"
}

variable "vm_role" {
  type        = map(string)
  default     = {
    web       = "web"
    db        = "db"
    storage   = "storage"
  }
}

### VM variables ###

variable "vm_family" {
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v3"
}

variable "vms_resources2" {
  type = map(object({
    vm_name = string
    cpu     = number
    ram     = number
    c_f     = number
    boot_disk_size    = number

  }))
  default = {
    "primary" = {
      vm_name = "main"
      cpu     = 4
      ram     = 4
      c_f     = 20
      boot_disk_size    = 10
    }
    "secondary" = {
      vm_name = "replica"
      cpu     = 2
      ram     = 2
      c_f     = 20
      boot_disk_size    = 5
    }
    "web" = {
      vm_name = "web"
      cpu     = 2
      ram     = 2
      c_f     = 20
      boot_disk_size    = 5
    }
  }
}
variable "vms_resources" {
  type        = map(number)
  default     = {
    cores     = 2
    ram       = 2
    c_f       = 20
  }
}

variable "vm_metadata" {
  default = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6foOs4ZPBpOGCI2Vde4xJGttURTff9SX9daFLWDsBD"
  }
}
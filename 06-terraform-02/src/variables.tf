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

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vpc_platform" {
  type        = string
  default     = "platform"
  description = "VPC network & subnet name"
}
variable "learning_platform" {
  type        = string
  default = "netology"
}


###ssh vars

/*
variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6foOs4ZPBpOGCI2Vde4xJGttURTff9SX9daFLWDsBD"
  description = "ssh-keygen -t ed25519"
}
*/

### Task2 vars - VM Specific

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
}
/*
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
}
*/
variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
}
/*
variable "vm_web_cores" {
  type        = number
  default     = 2
}

variable "vm_web_memory" {
  type        = number
  default     = 1
}

variable "vm_web_cores_fraction" {
  type        = number
  default     = 20
}
*/
### Task5 var - for locals

variable "vm_role" {
  type        = map(string)
  default     = {
    web       = "web"
    db        = "db"
  }
}

### Task6 - combo var for VM resources
variable "vms_resources" {
  type        = map(number)
  default     = {
    cores     = 2
    ram       = 2
    c_f       = 20
  }
}

### Task7 - create metadata var
variable "vm_metadata" {
  default = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6foOs4ZPBpOGCI2Vde4xJGttURTff9SX9daFLWDsBD"
  }
}
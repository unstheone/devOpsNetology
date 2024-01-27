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
  default     = "netology"
  description = "VPC network & subnet name"
}

variable "vm_name" {
  type    = string
  default = "vector"
}

variable "vm_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "vm_platform_id" {
  type    = string
  default = "standard-v3"
}

variable "vm_role" {
  type    = map(string)
  default = {
    web = "web"
    db  = "db"
  }
}

variable "vms_resources" {
  type    = map(number)
  default = {
    cores  = 2
    memory = 2
    c_f    = 20
  }
}
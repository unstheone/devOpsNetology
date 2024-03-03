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

variable "vm_family" {
  type    = map(string)
  default =  {
   ubuntu = "ubuntu-2004-lts"
   centos = "centos-7"
   jenkins-master = "jenkins-master"
   jenkins-agent = "jenkins-agent"
   teamcity = "jetbrains/teamcity-server"
  }
}

variable "vm_platform_id" {
  type    = string
  default = "standard-v1"
}

variable "vm_role" {
  type    = map(string)
  default = {
    master = "jenkins-master"
    agent  = "jenkins-agent"
    teamcity = "teamcity"
  }
}

variable "vms_resources" {
  type    = map(number)
  default = {
    cores  = 4
    memory = 4
    c_f    = 20
  }
}
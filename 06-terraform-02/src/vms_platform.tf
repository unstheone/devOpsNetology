### Task3 vars - db VM Specific

variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
}


/*
variable "vm_db_cores" {
  type        = number
  default     = 2
}

variable "vm_db_memory" {
  type        = number
  default     = 2
}

variable "vm_db_cores_fraction" {
  type        = number
  default     = 20
}
*/
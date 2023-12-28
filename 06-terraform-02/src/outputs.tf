output "vm_web_external_IP" {
  value = {
    "instance_name" = "${local.vm_name_local}-${var.vm_role["web"]}"
    "external_ip" = yandex_compute_instance.platform.network_interface[0].nat_ip_address
  }
}

output "vm_db_external_IP" {
  value = {
    "instance_name" = "${local.vm_name_local}-${var.vm_role["db"]}"
    "external_ip" = yandex_compute_instance.platform-db.network_interface[0].nat_ip_address
  }
}
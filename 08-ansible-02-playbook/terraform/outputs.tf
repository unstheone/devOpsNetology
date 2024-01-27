output "vm_external_IP" {
  value = {
    "instance_name" = yandex_compute_instance.vector.fqdn
    "external_ip" = yandex_compute_instance.vector.network_interface[0].nat_ip_address
    "internal_ip" = yandex_compute_instance.vector.network_interface[0].ip_address
  }
}
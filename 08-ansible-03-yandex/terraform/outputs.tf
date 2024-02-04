output "VMs" {
  value = {
    "instance_name" = yandex_compute_instance.vm[*].name
    "external_ip" = yandex_compute_instance.vm[*].network_interface[0].nat_ip_address
    "internal_ip" = yandex_compute_instance.vm[*].network_interface[0].ip_address
  }
}
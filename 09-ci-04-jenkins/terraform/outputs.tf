 output "VMs" {
  value = {
    "master_name" = yandex_compute_instance.jenkins-master.name
    "master_external_ip" = yandex_compute_instance.jenkins-master.network_interface[0].nat_ip_address
    "master_internal_ip" = yandex_compute_instance.jenkins-master.network_interface[0].ip_address
    "agent_name" = yandex_compute_instance.jenkins-agent.name
    "agent_external_ip" = yandex_compute_instance.jenkins-agent.network_interface[0].nat_ip_address
    "agent_internal_ip" = yandex_compute_instance.jenkins-agent.network_interface[0].ip_address
  }
 }
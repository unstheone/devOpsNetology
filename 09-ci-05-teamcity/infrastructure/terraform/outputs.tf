output "VMs" {
  value = {
    "instance_name" = yandex_serverless_container.teamcity.name
  }
}
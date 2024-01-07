output "vm_external_IP" {
  value = {
    "instance_name" = module.test-vm.fqdn
    "external_ip" = module.test-vm.external_ip_address
  }
}

output "vpc_net_id" {
  value = module.vpc_local.network_id
}

output "vpc_subnet_id" {
  value = module.vpc_local.subnet_id
}
resource "yandex_compute_instance" "db" {
  for_each = {
    primary   = "main"
    secondary = "replica"
  }
  name        = "${var.learning_platform}-${var.vpc_name}-${var.vpc_platform}-${var.vm_role["db"]}-${each.value}"
  platform_id = var.vm_platform_id
  resources {
    cores         = var.vms_resources2[each.key]["cpu"]
    memory        = var.vms_resources2[each.key]["ram"]
    core_fraction = var.vms_resources2[each.key]["c_f"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.vms_resources2[each.key]["boot_disk_size"]
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  metadata = {
    serial-port-enable = var.vm_metadata["serial-port-enable"]
    ssh-keys           = local.ssh-keys
  }
}
resource "yandex_compute_disk" "one-GB-disk" {
  count = 3
  size  = 1
  type  = "network-ssd"
}

resource "yandex_compute_instance" "storage" {
  depends_on = [yandex_compute_disk.one-GB-disk]
  name = "${var.learning_platform}-${var.vpc_name}-${var.vpc_platform}-${var.vm_role["storage"]}"
  platform_id = var.vm_platform_id
  resources {
    cores         = var.vms_resources["cores"]
    memory        = var.vms_resources["ram"]
    core_fraction = var.vms_resources["c_f"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  dynamic "secondary_disk" {
    for_each = "${yandex_compute_disk.one-GB-disk.*.id}"
    content {
      disk_id = yandex_compute_disk.one-GB-disk["${secondary_disk.key}"].id
    }
  }
  network_interface {
        subnet_id = yandex_vpc_subnet.develop.id
        nat     = true
  }
  metadata = {
        ssh-keys = local.ssh-keys
  }
}
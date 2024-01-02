resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_family
}

resource "yandex_compute_instance" "web" {
  depends_on  = [yandex_compute_instance.db]
  count       = 2
  name        = "${var.learning_platform}-${var.vpc_name}-${var.vpc_platform}-${var.vm_role["web"]}-${count.index+1}"
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
resource "yandex_vpc_network" "hw" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.hw.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_family
}

resource "yandex_compute_instance" "vector" {
  name        = var.vm_name
  platform_id = var.vm_platform_id
  resources {
    cores         = var.vms_resources["cores"]
    memory        = var.vms_resources["memory"]
    core_fraction = var.vms_resources["c_f"]
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}
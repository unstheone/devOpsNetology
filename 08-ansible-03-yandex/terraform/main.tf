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
  family = var.vm_family.ubuntu
}

data "yandex_compute_image" "centos" {
  family = var.vm_family.centos
}

resource "yandex_compute_instance" "vm" {
  count = 3
  name        = "${var.vm_name[count.index]}-01"
  platform_id = var.vm_platform_id
  hostname = "${var.vm_name[count.index]}-01"
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
      image_id = data.yandex_compute_image.centos.image_id
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
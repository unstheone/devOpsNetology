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
  family = var.vm_web_family
}
data "yandex_compute_image" "ubuntu-db" {
  family = var.vm_db_family
}
resource "yandex_compute_instance" "platform" {
  name        = "${local.vm_name_local}-${var.vm_role["web"]}"
  platform_id = var.vm_web_platform_id
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
    ssh-keys           = var.vm_metadata["ssh-keys"]
  }

}

resource "yandex_compute_instance" "platform-db" {
  name        = "${local.vm_name_local}-${var.vm_role["db"]}"
  platform_id = var.vm_db_platform_id
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
    ssh-keys           = var.vm_metadata["ssh-keys"]
  }

}

resource "yandex_vpc_network" "hw" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.hw.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "centos" {
  family = var.vm_family.centos
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_family.ubuntu
}

resource "yandex_container_registry" "my-registry" {
  name = "netology"
  folder_id = var.folder_id
  labels = {
    my-label = "netology"
  }
}

resource "yandex_container_repository" "my-repository" {
  name = "${yandex_container_registry.my-registry.id}/test-repository"
}


resource "yandex_serverless_container" "teamcity" {
  name        = var.vm_role.teamcity
  cores         = var.vms_resources["cores"]
  memory        = 4096
  image {
    url = "https://hub.docker.com/r/jetbrains/teamcity-server/"
  }
}
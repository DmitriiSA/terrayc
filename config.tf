terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "<YOUR_YANDEX_CLOUD_TOKEN>"
  cloud_id  = "<YOUR_CLOUD_ID>"
  folder_id = "<YOUR_FOLDER_ID>"
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "app-network" {
  name = "app-network"
}

resource "yandex_vpc_subnet" "app-subnet" {
  name           = "app-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.app-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Build instance ycvm1
resource "yandex_compute_instance" "ycvm1" {
  name        = "ycvm1"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 20.04 LTS
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.app-subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
     }
}

# ycvm2
resource "yandex_compute_instance" "ycvm2" {
  name        = "ycvm2"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 20.04 LTS
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.app-subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  depends_on = [yandex_compute_instance.build]
}

output "build_instance_ip" {
  value = yandex_compute_instance.build.network_interface.0.nat_ip_address
}

output "prod_instance_ip" {
  value = yandex_compute_instance.prod.network_interface.0.nat_ip_address

}

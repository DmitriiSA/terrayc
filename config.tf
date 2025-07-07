terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.13"
    }
  }

  required_version = ">= 0.13"
}
// Configure the Yandex Cloud Provider (Basic)
//
provider "yandex" {
  token     = "y0__xDp17ICGMHdEyDZlYPaE6oOaUU3fGGY1-SZRpw9rbEgUVcA"
  cloud_id  = "b1g21ko4q22qq9nssbl1"
  folder_id = "b1ghfja4e1sdv347eqa6"
  zone      = "ru-central1-d"
}

// Auxiliary resources for Compute Instance
resource "yandex_vpc_network" "default" {}

resource "yandex_vpc_subnet" "default-ru-central1-d" {
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.130.0.0/24"]
}

# Build instance ycvm1
resource "yandex_compute_instance" "ycvm1" {
   name        = "ycvm1"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 50
  }

  boot_disk {
      initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" # ОС Ubuntu 20.04 LTS
      size     =  10
      type     = "network-ssd"
    }
  }

  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.default-ru-central1-d.id
    //nat_ip_version = ipv4
    nat = true
    ipv4 = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
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
    core_fraction = 50
  }

  boot_disk {
      initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" # ОС Ubuntu 20.04 LTS
      size     =  10
      type     = "network-ssd"
    }
  }

  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.default-ru-central1-d.id
    //nat_ip_version = ipv4
    nat = true
    ipv4 = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }


  }


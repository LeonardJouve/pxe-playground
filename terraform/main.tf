variable "credentials" {
  type = string
}

variable "project" {
  type = string
}

variable "zone" {
  type = string
}

variable "ssh_user" {
  type = string
}

variable "ssh_pub_key" {
  type = string
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  zone        = var.zone
}

resource "google_compute_instance" "pxe_playground" {
  name         = "pxe-playground"
  machine_type = "n2-standard-8" # nested virtualization compatible

  advanced_machine_features {
    enable_nested_virtualization = true
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 100
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key)}"
  }
}

output "ip" {
  value = google_compute_instance.pxe_playground.network_interface[0].access_config[0].nat_ip
}

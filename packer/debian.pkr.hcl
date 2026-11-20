packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.1.0"
    }
  }
}

source "qemu" "debian" {
  iso_url          = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2"
  iso_checksum     = "file:https://cloud.debian.org/images/cloud/trixie/latest/SHA512SUMS"
  disk_image       = true
  skip_resize_disk = true
  format           = "raw"
  vm_name          = "debian.raw"
  headless         = true

  # cloud-init seed: sets the password of the debian user, kept in the image
  cd_label = "cidata"
  cd_content = {
    "meta-data" = ""
    "user-data" = <<-EOF
      #cloud-config
      password: debian
      chpasswd:
        expire: false
      ssh_pwauth: true
    EOF
  }

  ssh_username     = "debian"
  ssh_password     = "debian"
  shutdown_command = "sudo shutdown -P now"
}

build {
  sources = ["source.qemu.debian"]

  post-processor "compress" {
    output = "debian.raw.gz"
  }
}

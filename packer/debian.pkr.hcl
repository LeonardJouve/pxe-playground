packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.1.0"
    }
  }
}

variable "ssh_key_file" {
  default = "/var/lib/libvirt/ssh-key.pub"
}

source "qemu" "debian" {
  iso_url          = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2"
  iso_checksum     = "file:https://cloud.debian.org/images/cloud/trixie/latest/SHA512SUMS"
  disk_image       = true
  skip_resize_disk = true
  format           = "raw"
  vm_name          = "debian.raw"
  headless         = true

  cd_label = "cidata"
  cd_content = {
    "meta-data" = ""
    "user-data" = <<-EOF
      #cloud-config
      password: debian
      chpasswd:
        expire: false
      ssh_pwauth: true
      ssh_authorized_keys:
        - ${trimspace(file(var.ssh_key_file))}
      # Used by install.yaml to boot from the network once
      packages:
        - efibootmgr
      # cloud-init's network config matches this build VM's MAC: give any client card DHCP
      write_files:
        - path: /etc/systemd/network/99-dhcp.network
          content: |
            [Match]
            Name=en*

            [Network]
            DHCP=yes
    EOF
  }

  ssh_username     = "debian"
  ssh_password     = "debian"
  shutdown_command = "sudo shutdown -P now"
}

build {
  sources = ["source.qemu.debian"]

  post-processor "compress" {
    output = "output/debian.raw.gz"
  }
}

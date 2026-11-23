# PXE playground

A KVM host on GCP running a PXE server VM and blank client VMs that boot over the network.

- `terraform/`: creates the hypervisor host on GCP
- `ansible/`: sets up KVM, the PXE server and a client VM
- `ipmi.md`: powering physical nodes and setting PXE boot through their BMC

## Boot chain

```
UEFI firmware --DHCP-> dnsmasq: ipxe.efi over TFTP
iPXE          --DHCP-> dnsmasq: http://10.0.0.1/boot.ipxe
iPXE          --HTTP-> nginx: hosts/<mac>.ipxe, or exit
installer     --HTTP-> nginx: preseed.cfg, then images/debian.raw.gz written over the disk
```

## Note

The PXE server's dnsmasq does full DHCP and DNS on the `pxe` network. On a network where another server already gives out addresses, use dnsmasq's proxy DHCP mode instead.

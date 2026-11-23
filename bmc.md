# BMC

How to power a physical node and make it boot from PXE without touching it, through its BMC with either IPMI or Redfish.

## Concepts

- **BMC** (Baseboard Management Controller): a small computer on the server's motherboard, with its own network interface, IP, MAC and user accounts. It runs whenever the server has standby power, even when the server is off.

## Find the BMC address and accounts (in-band, on the node)

```sh
sudo ipmitool lan print 1            # IP Address, IP Address Source, MAC Address
sudo ipmitool user list 1            # user IDs, names, privilege
```

## IPMI

All commands use the same connection options:

```sh
export IPMI_PASSWORD='<pass>'
IPMI="ipmitool -I lanplus -H <bmc-ip> -U <user> -E"   # -E reads the password from IPMI_PASSWORD
```

### Power

```sh
$IPMI chassis power status
$IPMI chassis power on
$IPMI chassis power off      # hard off, like holding the button
$IPMI chassis power soft     # ACPI shutdown, the OS shuts down cleanly
$IPMI chassis power cycle    # off then on (only works when the node is on)
$IPMI chassis power reset    # hard reset
```

### Boot device

```sh
$IPMI chassis bootdev pxe options=efiboot          # next boot only, UEFI PXE
```

The override applies to the next boot only, then the node goes back to its normal boot order.

## Redfish

Redfish is the modern replacement for IPMI: JSON over HTTPS, same BMC, same accounts.

```sh
curl -sku <user>:<pass> https://<bmc-ip>/redfish/v1/Systems   # list system IDs
BMC=https://<bmc-ip>/redfish/v1/Systems/<system-id>    # Dell: System.Embedded.1
```

### Power

```sh
curl -sku <user>:<pass> $BMC | jq .PowerState
curl -sku <user>:<pass> -X POST $BMC/Actions/ComputerSystem.Reset \
  -H 'Content-Type: application/json' -d '{"ResetType": "On"}'
```

### Boot device

```sh
curl -sku <user>:<pass> -X PATCH $BMC -H 'Content-Type: application/json' \
  -d '{"Boot": {"BootSourceOverrideTarget": "Pxe", "BootSourceOverrideEnabled": "Once", "BootSourceOverrideMode": "UEFI"}}'
```

`Once` is the same as the IPMI next-boot override. `Continuous` keeps it.

# Ansible

## Setup

```sh
ansible-galaxy collection install -r requirements.yaml
cp inventory.yaml.example inventory.yaml
```

## Run

```sh
ansible-playbook -i inventory.yaml hypervisor.yaml
ansible-playbook -i inventory.yaml images.yaml
ansible-playbook -i inventory.yaml pxe-server-vm.yaml
```

### Get the PXE server address

```sh
ssh <user>@<hypervisor_ip> sudo virsh domifaddr pxe-server
```

### Continue

```sh
ansible-playbook -i inventory.yaml pxe-server.yaml
ansible-playbook -i inventory.yaml pxe-client-vm.yaml
ansible-playbook -i inventory.yaml install.yaml -e target=pxe-client
```

The install takes about 3 minutes.

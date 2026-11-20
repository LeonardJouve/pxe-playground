# Ansible

## Setup

```sh
ansible-galaxy collection install -r requirements.yaml
cp inventory.yaml.example inventory.yaml
```

## Run

```sh
ansible-playbook -i inventory.yaml hypervisor.yaml
ansible-playbook -i inventory.yaml pxe-server-vm.yaml
ansible-playbook -i inventory.yaml pxe-server.yaml
ansible-playbook -i inventory.yaml images.yaml
ansible-playbook -i inventory.yaml pxe-client-vm.yaml
```

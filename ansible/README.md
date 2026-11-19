# Ansible

## Setup

```sh
ansible-galaxy collection install -r requirements.yaml
cp inventory.yaml.example inventory.yaml
```

## Run

```sh
ansible-playbook -i inventory.yaml hypervisor.yaml
```

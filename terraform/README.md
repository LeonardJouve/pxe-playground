# Terraform

## Setup

```sh
gcloud auth application-default login
ssh-keygen -t ed25519 -f ~/.ssh/<key_name> -C <user>
cp terraform.tfvars.example terraform.tfvars
```

## Create

```sh
terraform init
terraform plan
terraform apply
```

## Connect

```sh
ssh -i ~/.ssh/<key_name> <user>@$(terraform output -raw ip)
```

## Destroy

```sh
terraform destroy
```

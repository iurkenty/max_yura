// AWS provider with default tags
provider "aws" {
  region = var.region
  #profile = var.profile

  default_tags {
    tags = {
   #Developer   = var.developer_name ##conflicts when 2 devs working on the same project
    Environment = "dev"
    Project     = "ci/cd"
  }
 }
}
// Ansible host and Terraform cloud
terraform {
  required_providers {
    ansible = {
      version = "1.0.0"
      source  = "ansible/ansible"
    }
  }
  cloud {
    organization = "iurkenty"
    workspaces {
      name = "AWS_Infra"
    }
  }
}
// Locals to consume with a developer variable must "export TF_VAR_developer_name="<name>"
locals {
  region      = "us-west-2"
  Project     = "ci/cd"
  Environment = "dev"
  Developer   = var.developer_name

}
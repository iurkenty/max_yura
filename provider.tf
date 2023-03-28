provider "aws" {
  region = var.region
  #profile = var.profile
}
terraform {
  required_providers {
  }
  cloud {
    organization = "iurkenty"
    workspaces {
      name = "AWS_Infra"
    }
  }
}
provider "aws" {
  region  = var.region
 #profile = var.profile
}
terraform {
  cloud {
    organization = "iurkenty"
    workspaces {
      name = "AWS_Infra"
    }
  }
}
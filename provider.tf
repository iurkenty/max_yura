provider "aws" {
  region = var.region
  #profile = var.profile

  default_tags {
    tags = {
    Developer = "max"
    Environemnt = "dev"
    Project  = "ci/cd"
  }
  }
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
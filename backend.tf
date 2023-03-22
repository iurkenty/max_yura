terraform {
  backend "remote" {
    organization = "max_yura"
    path = variable.backend

    workspaces {
      name = "aws_devops_prod"
    }
  }
}

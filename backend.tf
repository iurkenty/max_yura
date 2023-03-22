terraform {
  backend "remote" {
    organization = "max_yura"
    address = "s3"
    path    = variable.backend
    


    workspaces {
      name = "aws_devops_prod"
    }
  }
}
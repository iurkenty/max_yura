// Security groups
module "jenkins_sg" {
  source = "terraform-aws-modules/security-group/aws"
  description = "Security groups for Jenkins server"

  name        = "jenkins_server_sg"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]
}
data "aws_ami_ids" "ubuntu_ami" {
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/ubuntu-*-*-amd64-server-*"]
  }
}
// A key pair for SSH
module "jenkins_ssh_key" {
  source             = "terraform-aws-modules/key-pair/aws"
  key_name           = var.ssh_key_name
  create_private_key = true
}
// Jenkins server
module "jenkins_server" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = var.ec2_name
  ami                         = data.aws_ami_ids.ubuntu_ami.id
  key_name                    = module.jenkins_ssh_key.key_pair_name
  instance_type               = var.instance_type
  availability_zone           = module.vpc.azs[0]
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.jenkins_sg.security_group_id]
  associate_public_ip_address = var.public_ip_address_yes_no
  disable_api_stop            = false

  create_iam_instance_profile = var.create_instance_profile

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = false
      volume_type = var.root_volume_type
      throughput  = var.root_volume_throughput
      volume_size = var.root_block_size
      tags = {
        Name = "${var.ec2_name}-root-volume"
      }
    }
  ]
}
// TODO learn Ansible concepts to be able to provision the block below
// Ansible host for ec2 configuration
resource "ansible_host" "host" {
  name   = module.jenkins_server.public_dns
  groups = [""]

  variables = {

  }
}
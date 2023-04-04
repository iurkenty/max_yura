// Security groups
module "jenkins_sg" {
  source = "terraform-aws-modules/security-group/aws"
  description = "Security groups for Jenkins server"

  name        = "jenkins_server_sg"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "http-8080-tcp"]
  egress_rules        = ["all-all"]
}
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical account ID for Ubuntu
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
// A key pair for SSH
module "ssh_key" {
  source             = "terraform-aws-modules/key-pair/aws"
  key_name           = var.ec2_name
  create_private_key = true
}
resource "local_file" "ssh_key_pair" {
  filename = "${var.ec2_name}.pem"
  content  = module.ssh_key.private_key_pem
  file_permission = "0600"
}
resource "aws_eip" "eip" {
  instance = module.jenkins_server.id
  vpc      = true
}
resource "aws_eip_association" "eip_attach" {
  instance_id   = module.jenkins_server.id
  allocation_id = aws_eip.eip.id
}
output "eip" {
  value = aws_eip.eip.public_ip
}
// TODO ALB and ACM cert
// Jenkins server
module "jenkins_server" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = var.ec2_name
  ami                         = data.aws_ami.latest_ubuntu.id
  key_name                    = module.ssh_key.key_pair_name
  instance_type               = var.instance_type
  availability_zone           = module.vpc.azs[0]
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.jenkins_sg.security_group_id]
  associate_public_ip_address = var.public_ip_address_bool
  disable_api_stop            = false

  user_data                   = file("./jenkins.sh")
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
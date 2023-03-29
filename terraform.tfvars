// Provider
profile                = "GeneralAdminus"
region                 = "us-west-2"
// IAM idp
identity_provider_name = "azure_ad"
admin_policy_arn       = "arn:aws:iam::aws:policy/AdministratorAccess"
// VPC
vpc_name    = "my-vpc"
vpc_cidr    = "10.0.0.0/16"
nat_gateway = false
vpn_gateway = false
// EC2
ec2_name                 = "jenkins"
instance_type            = "t3.medium"
public_ip_address_yes_no = true
create_instance_profile  = false
root_volume_type         = "gp3"
root_volume_throughput   = 200
root_block_size          = 50
ssh_key_name             = "jenkins_key"
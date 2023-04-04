// Provider
variable "region" {}
variable "profile" {}
// IAM idp
variable "identity_provider_name" {}
variable "admin_policy_arn" {}
// Variable for developer tags
variable "developer_name" {}
// VPC
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "nat_gateway" {}
variable "vpn_gateway" {}
variable "dns_hostnames_bool" {}
// EC2
variable "ec2_name" {}
variable "instance_type" {}
variable "public_ip_address_bool" {}
variable "create_instance_profile" {}
variable "root_volume_type" {}
variable "root_volume_throughput" {}
variable "root_block_size" {}
variable "ssh_key_name" {}
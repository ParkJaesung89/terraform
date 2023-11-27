#  For EC2
variable "name" {}
variable "tags" {}
variable "az_names" {}
variable "instance_disable_termination" {}
variable "key_name" {}
variable "ec2_type_public" {}
#variable "ec2_type_private" {}
variable "volume_size" {}
variable "public_subnets" {}
#variable "private_subnets" {}
#variable "lb_subnets" {}

#  From module VPC
variable "pub_sub_ids" {}
#variable "pri_sub_ids" {}
#variable "lb_sub_ids" {}

#  From module IAM
variable "iam_instance_profile" {}

#  From module SG
variable "security_group_id_public" {}
#variable "security_group_id_private" {}

















###########
#variable "domain_name" {
#  description = "The domain name for which the certificate should be issued"
#  type        = string
#  default     = "terraform-aws-modules.modules.tf"
#}
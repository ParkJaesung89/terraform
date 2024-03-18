# Project name
variable "name" {}

# Tags
variable "tags" {}


# rds
variable "db_sub_ids" {}

variable "vpc_security_group_ids" {}

variable "engine" {
  default = "aurora-mysql"
}

variable "engine_mode" {
  default = "provisioned"
}

variable "engine_version" {
  default = "8.0.mysql_aurora.3.04.1"
}

variable "instance_class" {
  default = "db.r5.large"
}

variable "availability_zones" {
  type = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

#variable "storage_type" {
#  default = "io1"
#}

#variable "allocated_storage" {
#  default = "100"
#}

#variable "iops" {
#  default = "1000"
#}

variable "database_name" {
  default = "jsp"
}

variable "skip_final_snapshot" {
  default = "true"
}

variable "master_username" {
  default = "jsp"
}

#variable "master_password" {}
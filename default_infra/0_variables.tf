variable "region" {
  type        = string
  default     = "ap-northeast-2"
  description = "AWS region"
}

variable "name" {
  type        = string
  default     = "jsp"
  description = "name"
}

variable "cidr" {
  type        = string
  default     = "10.10.0.0/16"
  description = "cidr"
}

variable "pub_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "public cidr"
}

#variable "bucket_name" {
#  default     = "jsp-s3-${terraform.workspace}"
#} 

#variable "subnet" {
#  default        = [
#    "pub" ,
#    "pri" ,
#  ]
#  description = "sub type"
#}

module "vpc" {
  # Required
  source = "./vpc"

  # environment = var.environment
  name     = var.name
  tags     = var.tags
  az_names = var.az_names

  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  lb_subnets = var.lb_subnets
}


module "iam" {
  # Required
  source = "./iam"

  name = var.name
  tags = var.tags
}


module "ec2" {
  # Required
  source = "./ec2"

  name     = var.name
  tags     = var.tags
  az_names = var.az_names

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  lb_subnets = var.lb_subnets
  
  # module vpc
  pub_sub_ids = module.vpc.public_subnet_ids
  pri_sub_ids = module.vpc.private_subnet_ids
  lb_sub_ids  = module.vpc.lb_subnet_ids

  # module iam
  iam_instance_profile = module.iam.iam_instance_profile

  # module sg
  security_group_id_public  = module.sg.security_group_id_public
  security_group_id_private = module.sg.security_group_id_private
  

  instance_disable_termination = var.instance_disable_termination
  key_name                     = "${var.name}-key"
  volume_size                  = var.ec2_volume_size
  ec2_type_public              = var.ec2_type_public
  ec2_type_private             = var.ec2_type_private
}


module "sg" {
  # Required
  source = "./sg"

  name = var.name
  tags = var.tags

  public_ingress_rules  = var.public_ingress_rules
  private_ingress_rules = var.private_ingress_rules
  lb_ingress_rules = var.lb_ingress_rules

  # module vpc
  vpc_id = module.vpc.vpc_id
}

module "lb" {
  # Required
  source = "./lb"

  name = var.name
  tags = var.tags

  lb_subnets                = module.vpc.lb_subnet_ids
  security_group_id_lb      = module.sg.security_group_id_lb

  # for lb_listener
  #load_balancer_arn = var.lb_arn
  #port = var.lb_listener_port
  #port = "80"
  #protocol = var.lb_listener_protocol
  #protocol = "HTTP"
  
  # module vpc
  vpc_id = module.vpc.vpc_id
}
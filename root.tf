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
  lb_subnets_web = var.lb_subnets_web
  #lb_subnets_was = var.lb_subnets_was

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
  lb_subnets_web = var.lb_subnets_web
  #lb_subnets_was = var.lb_subnets_was 

  # module vpc
  pub_sub_ids = module.vpc.public_subnet_ids
  pri_sub_ids = module.vpc.private_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  
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

  web_lb_tg_arn                    = module.lb.web_lb_tg_arn
}


module "sg" {
  # Required
  source = "./sg"

  name = var.name
  tags = var.tags

  public_ingress_rules  = var.public_ingress_rules
  #public_egress_rules  = var.public_egress_rules

  #private_ingress_rules = var.private_ingress_rules
  private_egress_rules  = var.private_egress_rules

  web_lb_ingress_rules = var.web_lb_ingress_rules
  #web_lb_egress_rules = var.web_lb_egress_rules


  #was_lb_ingress_rules = var.was_lb_ingress_rules
  #was_lb_egress_rules = var.was_lb_egress_rules


  # module vpc
  vpc_id = module.vpc.vpc_id
}

module "lb" {
  # Required
  source = "./lb"

  name                     = var.name
  tags                     = var.tags
  internet_facing          = var.internet_facing
  #internal                 = var.internal
  security_group_id_lb_web = module.sg.security_group_id_lb_web
  #security_group_id_lb_was = module.sg.security_group_id_lb_was
  lb_subnets_web               = module.vpc.web_lb_subnet_ids # var.lb_subnets_web
  #lb_subnets_was               = module.vpc.was_lb_subnet_ids # var.lb_subnets_was
  vpc_id                   = module.vpc.vpc_id
  certificate_arn          = module.route53.acm_arn
  acm_validation           = module.route53.acm_validation

  providers = {
    aws.us-east-1 = aws.us-east-1
  }
}

module "route53" {
  source = "./route53"
  
  name        = var.name
  lb_dns_name = module.lb.lb_dns_name
  lb_zone_id  = module.lb.lb_zone_id

  cf_dns_name = module.cloudfront.cf_dns_name
  cf_zone_id = module.cloudfront.cf_zone_id

  providers = {
    aws.us-east-1 = aws.us-east-1
  }
}

module "cloudfront" {
  source = "./cloudfront"
  
  name                     = var.name
  tags                     = var.tags
  lb_dns_name              = module.lb.lb_dns_name
  cf_acm_arn                  = module.route53.cf_acm_arn
}
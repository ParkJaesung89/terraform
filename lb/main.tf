terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.us-east-1]
    }
  }
}

#################################################################################
#WEB
#################################################################################
#####################################
# Load Balancer

resource "aws_lb" "web_lb" {
  name               = format("%s-%s-web-lb", var.name, terraform.workspace)
  load_balancer_type = "application"
  internal           = var.internet_facing          # true or false
  security_groups    = [var.security_group_id_lb_web]
  
  subnets            = var.lb_subnets_web
  #subnets = toset(module.vpc.web_lb_subnet_ids)

## alb logs configuration
#  access_logs {
#    bucket  = aws_s3_bucket.{log_bucket}.vpc_id
#    prefix  = "frontend-alb"
#    enabled = true
#  }


  tags = merge(
    {
      Name = format(
        "%s-%s-web-lb",
        var.name,
        terraform.workspace
      )
    },
    var.tags,
  )
}


#####################################
# Load Balancer Target Group

resource "aws_lb_target_group" "web_lb_tg" {
  name     = format("%s-%s-web-lb-tg", var.name, terraform.workspace)
  #port     = 80
  port     = var.web_lb_tg_port
  #protocol = "HTTP"
  protocol = var.web_lb_tg_protocol
  vpc_id   = var.vpc_id

  health_check {

    path                = var.web_health_check_path
    timeout             = var.web_health_check_timeout
    interval            = var.web_health_check_interval
    healthy_threshold   = var.web_healthy_threshold
    unhealthy_threshold = var.web_unhealthy_threshold
    matcher             = var.web_health_check_matcher
  } 
}


#####################################
# Load Balancer Listener
resource "aws_lb_listener" "https_forward" {
  load_balancer_arn = aws_lb.web_lb.arn
  port = var.web_lb_listener_port_https
  protocol  = var.web_lb_listener_protocol_https
  certificate_arn = var.certificate_arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_lb_tg.id
  }

  depends_on = [var.certificate_arn, var.acm_validation]

}


resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web_lb.arn
  port = var.web_lb_listener_port_http
  protocol = var.web_lb_listener_protocol_http
    
  # if it differs from the listener rule, a 404 error page is displayed
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_lb_tg.id
  }

  depends_on = [var.certificate_arn, var.acm_validation]
}


resource "aws_lb_listener_rule" "static_page" {
  listener_arn = aws_lb_listener.web_http.arn
  priority     = 1

  action {
    type             = "redirect"
    
    redirect {
      port        = var.web_lb_listener_port_https
      protocol    = var.web_lb_listener_protocol_https
      status_code = "HTTP_301"
    }
  }
  
  condition {
    host_header {
      values = ["push.jsp-tech.store"]
    }

  }
}

######################################
## Load Balancer Listener_rule
#resource "aws_lb_listener_rule" "web_lb_rule" {
#  listener_arn = aws_lb_listener.web_http.arn
#  priority     = 100
#
#  condition {
#    path_pattern {
#      values = ["*"]
#    }
#  }
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.web_lb_tg.arn
#  }
#}




######################################
## Load Balancer Listener_certificate
#resource "aws_acm_certificate" "web_acm" {
#  domain_name       = var.domain_name
#  validation_method = "DNS"
#}
#
#resource "aws_lb_listener_certificate" "web_lb_certificate" {
#  listener_arn = aws_lb_listener.example.arn
#  certificate_arn = aws_acm_certificate.example.arn
#}








##################################################################################
##WAS
##################################################################################
#
## Load Balancer
#
#resource "aws_lb" "was_lb" {
#  name               = format("%s-%s-was-lb", var.name, terraform.workspace)
#  load_balancer_type = "application"
#  internal           = var.internal          # true or false
#  security_groups    = [var.security_group_id_lb_was]
#  
#  subnets            = var.lb_subnets_was
#  #subnets = toset(module.vpc.was_lb_subnet_ids)
#
#  tags = merge(
#    {
#      Name = format(
#        "%s-%s-was-lb",
#        var.name,
#        terraform.workspace
#      )
#    },
#    var.tags,
#  )
#}


#####################################
# Load Balancer Target Group

#resource "aws_lb_target_group" "was_lb_tg" {
#  name     = format("%s-%s-was-lb-tg", var.name, terraform.workspace)
#  #port     = 80
#  port     = var.was_lb_tg_port
#  #protocol = "HTTP"
#  protocol = var.was_lb_tg_protocol
#  vpc_id   = var.vpc_id
#
#  health_check {
#
#    path                = var.was_health_check_path
#    timeout             = var.was_health_check_timeout
#    interval            = var.was_health_check_interval
#    healthy_threshold   = var.was_healthy_threshold
#    unhealthy_threshold = var.was_unhealthy_threshold
#  } 
#}


#####################################
# Load Balancer Listener

#resource "aws_lb_listener" "was_http" {
#  load_balancer_arn = aws_lb.was_lb.arn
#  port = var.was_lb_listener_port
#  protocol = var.was_lb_listener_protocol
#    
#  # if it differs from the listener rule, a 404 error page is displayed
#  default_action {
#    target_group_arn = aws_lb_target_group.was_lb_tg.arn
#    type             = "forward"
#  }

#    default_action {
#        type = "fixed-response"
#
#        fixed_response {
#            content_type = "text/plain"
#            message_body = "404: page not found"
#            status_code = 404
#        }
#    }
#}


######################################
## Load Balancer Listener_rule
#resource "aws_lb_listener_rule" "was_lb_rule" {
#  listener_arn = aws_lb_listener.was_http.arn
#  priority     = 100
#
#  condition {
#    path_pattern {
#      values = ["*"]
#    }
#  }
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.was_lb_tg.arn
#  }
#}

#####################################
# Load Balancer

resource "aws_lb" "jsp_lb" {
  name               = format("%s-%s-lb", var.name, terraform.workspace)
  load_balancer_type = "application"
  internal           = var.internal          # public or false
  security_groups    = [var.security_group_id_lb]
  
  subnets            = var.lb_subnets
  #subnets = toset(module.vpc.lb_subnet_ids)

  tags = merge(
    {
      Name = format(
        "%s-lb",
        var.name
      )
    },
    var.tags,
  )
}


#####################################
# Load Balancer Listener

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.jsp_lb.arn
    port = var.lb_listener_port
    protocol = var.lb_listener_protocol
    
    # if it differs from the listener rule, a 404 error page is displayed
    default_action {
        target_group_arn = aws_lb_target_group.lb_tg.arn
        type             = "forward"
    }

#    default_action {
#        type = "fixed-response"
#
#        fixed_response {
#            content_type = "text/plain"
#            message_body = "404: page not found"
#            status_code = 404
#        }
#    }
}


#####################################
# Load Balancer Target Group

resource "aws_lb_target_group" "lb_tg" {
  name     = format("%s-%s-lb-tg", var.name, terraform.workspace)
  #port     = 80
  port     = var.lb_tg_port
  #protocol = "HTTP"
  protocol = var.lb_tg_protocol
  vpc_id   = var.vpc_id

  health_check {

    path                = var.health_check_path
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  } 
}

######################################
## Load Balancer Listener_certificate
#resource "aws_acm_certificate" "jsp_acm" {
#  domain_name       = var.domain_name
#  validation_method = "DNS"
#}
#
#resource "aws_lb_listener_certificate" "jsp_lb_certificate" {
#  listener_arn = aws_lb_listener.example.arn
#  certificate_arn = aws_acm_certificate.example.arn
#}
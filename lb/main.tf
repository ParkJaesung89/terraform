######################################
## Load Balancer

resource "aws_lb" "jsp_lb" {
  name               = format("%s-%s-lb", var.name, terraform.workspace)
  load_balancer_type = "application"
  internal           = false          # public
  security_groups    = [var.security_group_id_lb]
  subnets            = var.lb_subnets

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


######################################
## Load Balancer Listener

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.jsp_lb.arn
    port = 80
    #port = var.lb_listener_port
    protocol = "HTTP"
    #protocol = var.lb_listener_protocol

    # if it differs from the listener rule, a 404 error page is displayed
    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code = 404
        }
    }
}


######################################
## Load Balancer Target Group

resource "aws_lb_target_group" "lb_tg" {
  name     = format("%s-%s-lb-tg", var.name, terraform.workspace)
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  } 
}

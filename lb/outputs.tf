output "web_lb_tg_arn" {
    value = aws_lb_target_group.web_lb_tg.arn
}

output "lb_dns_name" {
  value = aws_lb.web_lb.dns_name
}

output "lb_zone_id" {
  value = aws_lb.web_lb.zone_id
}

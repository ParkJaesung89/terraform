resource "aws_acm_certificate" "jsp-tech-acm" {
    domain_name       = "jsp-tech.store"
    subject_alternative_names = [ "*.jsp-tech.store" ]
    validation_method = "DNS"
    lifecycle {
        create_before_destroy = true
    }
    tags = {
      Name = format(
        "%s-%s-acm",
        var.name,
        terraform.workspace
      )
    }
}
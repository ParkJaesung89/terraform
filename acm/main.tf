resource "aws_acm_certificate" "sangchulkr" {
    domain_name       = "sangchul.kr"
    subject_alternative_names = [ "*.sangchul.kr" ]
    validation_method = "DNS"
    lifecycle {
        create_before_destroy = true
    }
    tags = {
      Name = format(
        "%s-%s-acm",
        var.name,
        terraform.workspace
    }
}
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

resource "aws_wafv2_ip_set" "ipset_global" {
  provider          = aws.us-east-1
  name                  = "block_ips"
  scope                 = "CLOUDFRONT"
  ip_address_version    = "IPV4"
  addresses             = var.waf_ip_sets
}

resource "aws_wafv2_web_acl" "waf_acl" {
  provider          = aws.us-east-1
  name                  = "${var.waf_prefix}-generic-acl"
  scope                 = "CLOUDFRONT"
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled  = true
    sampled_requests_enabled    = true
    metric_name                 = "global-rule"
  }

  dynamic "rule" {
    for_each = var.managed_rules
    content {
      name      = rule.value.name
      priority  = rule.value.priority
      override_action {
        count {}           # allow, block 으로 지정하지 않고 다음 룰에 결정을 넘기는 값.
      }
      statement {
        managed_rule_group_statement {
          name  = rule.value.name
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled  = true
        sampled_requests_enabled    = true
        metric_name                 = rule.value.name
      }
    }
  }

  rule {
    name = "block_ips"
    priority = 1
    action {
        block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipset_global.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled    = true
      sampled_requests_enabled      = true
      metric_name                   = "block_ips"
    }
  }
}

resource "aws_cloudwatch_log_group" "waf_logging" {
  provider          = aws.us-east-1
  name = "aws-waf-logs-${var.waf_prefix}"
}


resource "aws_wafv2_web_acl_logging_configuration" "logging_configuration" {
  provider          = aws.us-east-1
  log_destination_configs   = [aws_cloudwatch_log_group.waf_logging.arn]
  resource_arn              = aws_wafv2_web_acl.waf_acl.arn
}

# WAF ACL
resource "aws_wafv2_web_acl" "waf" {
  name        = "waf"
  description = "WAF for  ALB"
  scope       = "REGIONAL" 

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "-waf"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "common-rule-set"
      sampled_requests_enabled   = true
    }
  }
  
  tags = {
    Name        = "waf-${var.environment}"
    Environment = var.environment
  }
}

# WAF association with ALB
resource "aws_wafv2_web_acl_association" "waf_assoc" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}






resource "aws_wafv2_web_acl" "regional" {
    name        = var.webacl_name
    description = var.webacl_description
    scope       = var.regional_scope

    default_action {
        allow {}
    }
    
    tags = {
        "Automated" = "yes"
    }
#Terraform dynamic blocks are used to create repeatable nested blocks inside an argument.
#https://jeffbrown.tech/terraform-dynamic-blocks/
    dynamic "rule" {
      for_each = var.managed_rules

      content {
        name = rule.value.name
        priority = rule.value.priority

        override_action {
          dynamic "none" {
              for_each = rule.value.override_action == "none" ? [1] : []
              content {}
          }

          dynamic "count" {
              for_each = rule.value.override_action == "count" ? [1] : []
              content {}
          }
        }
        statement {
          managed_rule_group_statement {
            name = rule.value.name
            vendor_name = lookup(var.vendor_name, "vendor_name", "AWS")

            dynamic "excluded_rule" {
                for_each = rule.value.excluded_rules
                content {
                    name = excluded_rules.value
                }
            }
          }
        }
        visibility_config {
          cloudwatch_metrics_enabled = true 
          metric_name                = "${rule.value["name"]}-metric"
          sampled_requests_enabled   = true
        }
      }
    }  
    visibility_config {
      metric_name = "waf-main-metrics"
      cloudwatch_metrics_enabled = true 
      sampled_requests_enabled = true
    }
  }

# resource "aws_wafv2_web_acl_association" "main" {
#   resource_arn = alb_arn
#   web_acl_arn  = aws_wafv2_web_acl.regional.arn
# }



  output "regional_waf_acl" {
    value = aws_wafv2_web_acl.regional.arn

  }

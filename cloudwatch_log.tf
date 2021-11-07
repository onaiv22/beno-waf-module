resource "aws_cloudwatch_log_group" "waf_logs" {
    name = "/aws/kinesisfirehose/aws-waf-logs"
    retention_in_days = "7"

    tags = {
        "Automated" = "yes"
    }
}

resource "aws_cloudwatch_log_stream" "waf_logs" {
    name = "S3Delivery"
    log_group_name = aws_cloudwatch_log_group.waf_logs.name
}


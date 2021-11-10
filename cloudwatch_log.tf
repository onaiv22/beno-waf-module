resource "aws_cloudwatch_log_group" "global_waf_logs" {
    name = "/aws/kinesisfirehose/global-waf-logs"
    retention_in_days = "7"

    tags = {
        "Automated" = "yes"
    }
}

resource "aws_cloudwatch_log_stream" "global_waf_logs" {
    name = "GlobalS3Delivery"
    log_group_name = aws_cloudwatch_log_group.global_waf_logs.name
}

resource "aws_cloudwatch_log_group" "regional_waf_logs" {
    name = "/aws/kinesisfirehose/regional-waf-logs"
    retention_in_days = "7"

    tags = {
        "Automated" = "yes"
    }
}

resource "aws_cloudwatch_log_stream" "regional_waf_logs" {
    name = "RegionalS3Delivery"
    log_group_name = aws_cloudwatch_log_group.regional_waf_logs.name
}



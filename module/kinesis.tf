resource "aws_kinesis_firehose_delivery_stream" "waf_log_stream" {
    name = "aws-waf-logs-stream"
    destination = "extended_s3"

    extended_s3_configuration {
        role_arn = aws_iam_role.waf_logs_firehose_role.arn
        buckeet_arn = aws_s3_bucket.waf_logs.arn 
        buffer_size = 5
        buffer_interval = 300
        compression_format = "GZIP"
        prefix = "wafv2/year=!{timestamp:YYYY}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
        error_output_prefix = "errors/wafv2/!{firehose:random-string}/!{firehose:error-output-type}/!{timestamp:yyyy/MM/dd}/"
        cloudwatch_logging_options {
            enabled = true 
            log_group_name = aws_cloudwatch_log_group.waf_logs.name 
            log_stream_name = aws_cloudwatch_log_stream.waf_logs.name
        }
    }


}
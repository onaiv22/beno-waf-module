resource "aws_kinesis_firehose_delivery_stream" "global_waf_logs_stream" {
    name = "aws-waf-logs-global-stream"
    destination = "extended_s3"

    extended_s3_configuration {
        role_arn = aws_iam_role.waf_logs_firehose_role.arn
        bucket_arn = aws_s3_bucket.waf_logs.arn 
        buffer_size = 5
        buffer_interval = 300
        compression_format = "GZIP"
        prefix = "global/year=!{timestamp:YYYY}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
        #requires an error prefix if using the prrefix variable
        error_output_prefix = "errors/global/!{firehose:random-string}/!{firehose:error-output-type}/!{timestamp:yyyy/MM/dd}/"
        cloudwatch_logging_options {
            enabled = true 
            log_group_name = aws_cloudwatch_log_group.global_waf_logs.name 
            log_stream_name = aws_cloudwatch_log_stream.global_waf_logs.name
        }
    }
}

resource "aws_wafv2_web_acl_logging_configuration" "global" {
    log_destination_configs = [aws_kinesis_firehose_delivery_stream.global_waf_logs_stream.arn]
    resource_arn            = aws_wafv2_web_acl.global.arn 
    redacted_fields {     #this is the parts of the request that you dont want to log e.g all_query_arguments, single_header, uri_path, method, body, single_query_argument etc
        single_header {
            name = "user_agent"
        }
    }      
}

resource "aws_kinesis_firehose_delivery_stream" "regional_waf_logs_stream" {
    name = "aws-waf-logs-regional-stream"
    destination = "extended_s3"

    extended_s3_configuration {
        role_arn = aws_iam_role.waf_logs_firehose_role.arn
        bucket_arn = aws_s3_bucket.waf_logs.arn 
        buffer_size = 5
        buffer_interval = 300
        compression_format = "GZIP"
        prefix = "regional/year=!{timestamp:YYYY}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
        #requires an error prefix if using the prrefix variable
        error_output_prefix = "errors/regional/!{firehose:random-string}/!{firehose:error-output-type}/!{timestamp:yyyy/MM/dd}/"
        cloudwatch_logging_options {
            enabled = true 
            log_group_name = aws_cloudwatch_log_group.regional_waf_logs.name 
            log_stream_name = aws_cloudwatch_log_stream.regional_waf_logs.name
        }
    }
}

resource "aws_wafv2_web_acl_logging_configuration" "regional" {
    log_destination_configs = [aws_kinesis_firehose_delivery_stream.regional_waf_logs_stream.arn]
    resource_arn            = aws_wafv2_web_acl.regional.arn 
    redacted_fields {     #this is the parts of the request that you dont want to log e.g all_query_arguments, single_header, uri_path, method, body, single_query_argument etc
        single_header {
            name = "user_agent"
        }
    }      
}
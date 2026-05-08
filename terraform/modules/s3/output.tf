output "s3_access_logs_alb" {
    value = aws_s3_bucket.alb_logs.bucket
}
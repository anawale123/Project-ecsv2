output "sqs_queue_name" {
  value = aws_sqs_queue.sqs_queue.name
}

output "dlq_queue_name" {
  value = aws_sqs_queue.dlq_messages.name
}
resource "aws_sqs_queue" "dlq_messages" {
  name = "sqs-queue-dlq"
}

resource "aws_sqs_queue" "sqs_queue" {
  name                      = "sqs-queue"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_messages.arn
    maxReceiveCount     = 3
  })

  tags = {
    Environment = "sqs"
  }
}

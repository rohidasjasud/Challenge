

resource "aws_sqs_queue" "demo-queue" {
  name                      = "demo-queue"
  delay_seconds             = 10
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 20
  sqs_managed_sse_enabled = true
    tags = {
    Name = "demo-queue"
    Environment = "demo"
  }
}




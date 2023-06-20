# Create ECR for demo
resource "aws_ecr_repository" "demo-ecr-repository" {
  name                 = "demo-ecr-repository"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
   encryption_type = "KMS"
  }
  image_scanning_configuration {
    scan_on_push = true
  }
}




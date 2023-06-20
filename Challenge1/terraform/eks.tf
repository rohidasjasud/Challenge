

# Create IAM Role For EKS Cluster
resource "aws_iam_role" "demo-eksclusterrole" {
  name = "demo-eksclusterrole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

 lifecycle {
    prevent_destroy = false
  }
}

# Attach AmazonEKSClusterPolicy to the Role
resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo-eksclusterrole.name

   lifecycle {
    prevent_destroy = false
  }
}


# Create EKS Cluster

resource "aws_eks_cluster" "demo-EKS-Cluster" {
  name     = "demo-EKS-Cluster"
  role_arn = aws_iam_role.demo-eksclusterrole.arn
  enabled_cluster_log_types = ["api","audit","authenticator","controllerManager","scheduler"]
  encryption_config {
    provider {
      key_arn = aws_kms_key.demo-EKS-CMK.arn
    }
    resources = ["secrets"]
    
  }
  vpc_config {
    subnet_ids = [
      
      aws_subnet.demo-PrivatesubnetA.id,
      aws_subnet.demo-PrivatesubnetB.id
      
    ]
    security_group_ids = [aws_security_group.demo-EKS-Securitygroup.id]
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy]

   lifecycle {
    prevent_destroy = false
  }

}

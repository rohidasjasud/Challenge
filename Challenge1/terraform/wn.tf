#create Node group for eks cluster
 resource "aws_eks_node_group" "demo-Nodegroup" {
  cluster_name  = aws_eks_cluster.demo-EKS-Cluster.name
  node_group_name = "demo-Nodegroup"
  node_role_arn  = aws_iam_role.demo-WorkerNoderole.arn
  subnet_ids   = [aws_subnet.demo-PrivatesubnetA.id , aws_subnet.demo-PrivatesubnetB.id]
  instance_types = ["m5.2xlarge"] 
  scaling_config {
   desired_size = 1
   max_size   = 1
   min_size   = 1
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
 }

#Create the node group for demo 
 resource "aws_eks_node_group" "demo" {
  cluster_name  = aws_eks_cluster.demo-EKS-Cluster.name
  node_group_name = "central"
  node_role_arn  = aws_iam_role.demo-WorkerNoderole.arn
  subnet_ids   = [aws_subnet.demo-PrivatesubnetA.id , aws_subnet.demo-PrivatesubnetB.id]
  instance_types = ["m5.2xlarge"]
  taint {
    key = "pool-name"
    value = "central"
    effect = "NO_SCHEDULE"
  }

  labels = {
        "agentpool" = "central"
  }
 
  scaling_config {
   desired_size = 1
   max_size   = 1
   min_size   = 1
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
 }


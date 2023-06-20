#Create  Subnet group for Elasticache Cluster
resource "aws_elasticache_subnet_group" "demo-Redis-SubnetGroup" {
  name       = "demo-Redis-SubnetGroup"
  subnet_ids = [aws_subnet.demo-PrivatesubnetA.id , aws_subnet.demo-PrivatesubnetB.id]
    tags = {
    Name = "demo-Redis-SubnetGroup"
  }
}

# Create Elasticache demo Cluster
resource "aws_elasticache_replication_group" "demo-redis-cluster" {
  automatic_failover_enabled  = true
  preferred_cache_cluster_azs = ["us-east-1a", "us-east-1b"]
  replication_group_id        = "demo-redis-cluster"
  description                 = "demo-redis-cluster-group description"
  node_type                   = "cache.m4.large"
  num_cache_clusters          = 2
  parameter_group_name        = "default.redis7"
  port                        = 6379
  multi_az_enabled            = true
  subnet_group_name           = aws_elasticache_subnet_group.demo-Redis-SubnetGroup.id
  security_group_ids          = [aws_security_group.demo-Redis-sg.id]
}






# Create Aurora Cluster
  resource "aws_rds_cluster" "demo-Aurora-Cluster" {
    cluster_identifier = "demoauroracluster"
    engine             = "aurora-postgresql"
    availability_zones = [var.availability_zone_names[0], var.availability_zone_names[1]]
    database_name      = "outfront"
    db_subnet_group_name  = aws_db_subnet_group.demouction-PostgresRDS-SubnetGroup.id
    master_username    = "outfront"
    master_password    = "outfront"
    vpc_security_group_ids   = ["${aws_security_group.demo-PostgresRDS-sg.id}"]
    skip_final_snapshot      = true
    apply_immediately = true
    backup_retention_period = 0

 }

# resource "aws_rds_cluster_instance" "cluster_instances" {

  resource "aws_rds_cluster_instance" "cluster_instances" {
    count              = 2
    identifier         = "demoauroracluster-${count.index}"
    cluster_identifier = aws_rds_cluster.demo-Aurora-Cluster.id
    instance_class     = "db.r5.2xlarge"
    engine             = aws_rds_cluster.demo-Aurora-Cluster.engine
    engine_version     = aws_rds_cluster.demo-Aurora-Cluster.engine_version
}

# Create Database Subnet Group
# terraform aws db subnet group
resource "aws_db_subnet_group" "demo-PostgresRDS-SubnetGroup" {
  name         = "database subnets"
  subnet_ids   = [aws_subnet.demo-PrivatesubnetA.id, aws_subnet.demo-PrivatesubnetB.id]
  description  = "Subnets for Database Instance"

  tags   = {
    Name = "Database Subnets"
  }
}

 
# terraform aws data db snapshot
data "aws_db_snapshot" "latest-db-snapshot" {
  db_snapshot_identifier = "${var.database-snapshot-identifier}"
  most_recent            = true
  snapshot_type          = "manual"
}
 
# terraform aws db instance
resource "aws_db_instance" "database-instance" {
  instance_class          = "${var.database-instance-class}"
  skip_final_snapshot     = true
  availability_zone       = "us-east-1a"
  identifier              = "${var.database-instance-identifier}"
  snapshot_identifier     = data.aws_db_snapshot.latest-db-snapshot.id
  db_subnet_group_name    = aws_db_subnet_group.demo-PostgresRDS-SubnetGroup.name
  multi_az                = "${var.multi-az-deployment}"
  vpc_security_group_ids  =  [aws_security_group.demo-PostgresRDS-sg.id]
}
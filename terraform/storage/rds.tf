resource "aws_rds_global_cluster" "global" {
  global_cluster_identifier = "myapp-global-db"
  engine                    = "aurora-postgresql"
  engine_version = "15.8"
  storage_encrypted   = true

}


resource "aws_db_subnet_group" "psl-subnet-us-east-1" {

  name       = "rds_subnet_group-us-east-1"
  subnet_ids = [data.terraform_remote_state.network.outputs.subnet1-us-east-1,data.terraform_remote_state.network.outputs.subnet2-us-east-1]

  tags = {
    Name = "Primary DB subnet group"
  }
}

resource "aws_db_subnet_group" "psl-subnet-us-east-2" {
  provider = aws.us_east_2

  name       = "rds_subnet_group-us-east-2"
  subnet_ids = [
    data.terraform_remote_state.network.outputs.subnet1-us-east-2,
    data.terraform_remote_state.network.outputs.subnet2-us-east-2
  ]

  tags = {
    Name = "Replica DB subnet group"
  }
}


resource "aws_rds_cluster" "primary" {
  cluster_identifier         = "myapp-aurora-primary"
  engine                     = "aurora-postgresql"
  engine_version = "15.8"
  global_cluster_identifier  = aws_rds_global_cluster.global.id
  master_username = ""
  master_password = ""

  db_subnet_group_name   = aws_db_subnet_group.psl-subnet-us-east-1.name
  vpc_security_group_ids = [
    data.terraform_remote_state.network.outputs.security_groups-us-east-1
  ]

  backup_retention_period = 7
  preferred_backup_window = "03:00-04:00"

  storage_encrypted     = true
  kms_key_id        = aws_kms_key.rds_primary.arn
  skip_final_snapshot   = true

  tags = {
    Name = "Aurora Primary Cluster"
  }
}


resource "aws_rds_cluster_instance" "primary_instance" {
  identifier         = "myapp-aurora-writer"
  cluster_identifier = aws_rds_cluster.primary.id
  instance_class     = ${var.instance_class}
  engine             = aws_rds_cluster.primary.engine

  tags = {
    Name = "Aurora Writer"
  }
}

resource "aws_rds_cluster" "secondary" {
  provider = aws.us_east_2


  cluster_identifier         = "myapp-aurora-secondary"
  engine                     = "aurora-postgresql"
  engine_version             = "15.8"
  global_cluster_identifier  = aws_rds_global_cluster.global.id


  db_subnet_group_name   = aws_db_subnet_group.psl-subnet-us-east-2.name
  vpc_security_group_ids = [
    data.terraform_remote_state.network.outputs.security_groups-us-east-2
  ]

  storage_encrypted   = true
  skip_final_snapshot = true
  kms_key_id        = aws_kms_key.rds_secondary.arn

  tags = {
    Name = "Aurora Secondary Cluster"
  }
}


resource "aws_rds_cluster_instance" "secondary_instance" {
  provider = aws.us_east_2

  identifier         = "myapp-aurora-reader"
  cluster_identifier = aws_rds_cluster.secondary.id
  instance_class     = ${var.instance_class}
  engine             = aws_rds_cluster.secondary.engine

  tags = {
    Name = "Aurora Reader"
  }

  depends_on = [
    aws_rds_cluster.primary,
    aws_rds_cluster_instance.primary_instance 
  ]
}


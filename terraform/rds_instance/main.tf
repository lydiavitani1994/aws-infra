resource "aws_db_subnet_group" "private_subnet_group" {
  name       = var.private_subnet_group_name
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = var.private_subnet_group_tag_name
  }
}

resource "aws_db_instance" "db_instance" {
  allocated_storage = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  multi_az = var.multi_az
  identifier = var.identifier
  username             = var.username
  password             = var.password
  db_name              = var.db_name
  publicly_accessible = var.publicly_accessible
  db_subnet_group_name = aws_db_subnet_group.private_subnet_group.name
  parameter_group_name = var.parameter_group_name
  vpc_security_group_ids = ["${var.security_group_id}"]
  skip_final_snapshot  = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
  apply_immediately = var.apply_immediately
  # final_snapshot_identifier = "test"
}

resource "random_password" "db_password" {
  length  = 16
  special = false

}

resource "aws_secretsmanager_secret" "db_password" {
  name                    = "db-password"
  kms_key_id              = aws_kms_key.secret_manager_key.arn
  recovery_window_in_days = 0

}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({ password = random_password.db_password.result })
}
resource "aws_db_parameter_group" "custom_pg" {
  family = "mysql8.0" # Adjust based on your DB engine and version
  name   = "csye6225-mysql"

  parameter {
    name         = "max_connections"
    value        = "100"
    apply_method = "pending-reboot"
  }

  # Add more parameters as needed
}

resource "aws_db_instance" "csye6225_db" {
  identifier        = "csye6225"
  engine            = "mysql"
  engine_version    = "8.0.40"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = "csye6225"
  username          = "csye6225"
  # password             = var.db_password
  password             = random_password.db_password.result
  kms_key_id           = aws_kms_key.rds_kms_key.arn
  storage_encrypted    = true
  parameter_group_name = aws_db_parameter_group.custom_pg.name
  skip_final_snapshot  = true
  multi_az             = false
  publicly_accessible  = false
  apply_immediately    = true

  vpc_security_group_ids = [aws_security_group.database_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.private.name

  tags = {
    Name = "${var.project_name}-rds"
  }
}

resource "aws_db_subnet_group" "private" {
  name       = "csye6225-private-subnet-group"
  subnet_ids = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id, aws_subnet.private_subnet[2].id]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}
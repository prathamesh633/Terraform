# Create an RDS MySQL Instance
resource "aws_db_instance" "cbz_db_instance" {
  allocated_storage    = 20
  max_allocated_storage = 100
  engine               = var.engine #"mysql"
  engine_version       = var.engine-version #"8.0"
  instance_class       = var.rds-type # Free-tier eligible instance type  "db.t3.micro"
  username             = var.username #"admin"
  password             = var.password #"Redhat123"
  parameter_group_name = var.parameter-group-name #"default.mysql8.0"
  publicly_accessible  = true
  vpc_security_group_ids = var.security-group-ids #[aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.cbz_db_subnet_group.name #aws_db_subnet_group.default.name
  skip_final_snapshot  = true
  tags = {
    Name = var.rds-name #"cbz-db-instance"
  }
}

# Create a DB Subnet Group using default subnets
resource "aws_db_subnet_group" "cbz_db_subnet_group" {
  name       = "db-subnet-group-1"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "db-subnet-group"
  }
}

resource "aws_vpc" "rds_vpc" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "rds-vpc"
  }
}

resource "aws_subnet" "rds_subnet_1" {
  vpc_id                  = aws_vpc.rds_vpc.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "rds-subnet-1"
  }
}

resource "aws_subnet" "rds_subnet_2" {
  vpc_id                  = aws_vpc.rds_vpc.id
  cidr_block              = "10.20.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "rds-subnet-2"
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name = "my-db-subnet-group"

  subnet_ids = [
    aws_subnet.rds_subnet_1.id,
    aws_subnet.rds_subnet_2.id
  ]

  tags = {
    Name = "my-db-subnet-group"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "rds-mysql-sg"
  description = "Allow MySQL access from the VPC"
  vpc_id      = aws_vpc.rds_vpc.id

  ingress {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-mysql-sg"
  }
}

resource "aws_db_instance" "primary" {
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  identifier              = "mydbinstance"

  username                = "admin"
  password                = "Cloud123"

  db_subnet_group_name    = aws_db_subnet_group.my_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]

  publicly_accessible     = false
  skip_final_snapshot     = true
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_retention_period = 7

  tags = {
    Name = "mydbinstance"
  }
}

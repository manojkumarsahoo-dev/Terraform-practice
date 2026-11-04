# AWS Provider
provider "aws" {
  region = "us-east-1"
}

# EC2 Instance - SQL Runner
resource "aws_instance" "sql_runner" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  key_name                    = "my-key"
  associate_public_ip_address = true

  tags = {
    Name = "SQL Runner"
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "mysql_rds" {
  identifier          = "my-mysql-db"
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "Password123!"
  db_name              = "dev"
  allocated_storage   = 20
  skip_final_snapshot = true
  publicly_accessible = true
}

# Execute SQL Script Remotely Using EC2
resource "null_resource" "remote_sql_exec" {

  depends_on = [
    aws_db_instance.mysql_rds,
    aws_instance.sql_runner
  ]

  # SSH Connection
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/Acer/Downloads/my-key.pem")
    host        = aws_instance.sql_runner.public_ip
  }

  # Upload SQL File to EC2
  provisioner "file" {
    source      = "init.sql"
    destination = "/tmp/init.sql"
  }

  # Install MySQL Client and Execute SQL
  provisioner "remote-exec" {
    inline = [
      "sudo yum install mariadb -y",
      "mysql --version",
      "ls -l /tmp/init.sql",
      "mysql -h ${aws_db_instance.mysql_rds.address} -u admin -p'Password123!' dev < /tmp/init.sql"
    ]
  }

  # Execute Again When init.sql Changes
  triggers = {
    sql_file = filemd5("init.sql")
  }
}
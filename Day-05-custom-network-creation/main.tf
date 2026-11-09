
# Creation of VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "custom-vpc"
  }
}

# Creation of Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-1"
  }
}

# Creation of Internet Gateway
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

# Creation of Route Table
resource "aws_route_table" "dev_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }

  tags = {
    Name = "dev-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "dev_route_table_association" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.dev_route_table.id
}

# Creation of Security Group
resource "aws_security_group" "custom_sg" {
  name        = "custom-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.custom_vpc.id

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "custom-sg"
  }
}

# Creation of EC2 Instance
resource "aws_instance" "custom_instance" {
  ami                         = "ami-08c46876c64a927b8"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet-1.id
  vpc_security_group_ids      = [aws_security_group.custom_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "custom-instance"
  }
}

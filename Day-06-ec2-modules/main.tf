resource "aws_instance" "name" {
  ami           = var.ami
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  tags = {
    Name = "dev-instance"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "sdfghjkertyu"
}
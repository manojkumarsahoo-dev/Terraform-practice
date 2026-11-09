
resource "aws_instance" "name" {
  ami               = "ami-04b93843b7b69a2c9c"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"

  tags = {
    Name = "manoj"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "manoj-terraform-practice-20261025"
}
        
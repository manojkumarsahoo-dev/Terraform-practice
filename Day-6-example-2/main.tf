module "test" {
  source = "../Day-6-ec2-modules"
  ami = "ami-04b938437b69a2c9c"
  instance_type = "t2.micro"
  availability_zone = "us-east-1b"
  tags = "dev-instance"
}

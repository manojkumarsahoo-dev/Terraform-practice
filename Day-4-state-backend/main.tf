resource "aws_instance" "name" {
    ami = "ami-0d27e0fb3bac4d724"
    instance_type = "t2.micro"
    availability_zone = "us-east-1b"
    tags = {
        Name = "veera"
    }

  
}

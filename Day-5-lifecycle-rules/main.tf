resource "aws_instance" "name" {
    ami = "ami-04b938437b69a2c9c"
    instance_type = "t2.micro"
    availability_zone = "us-east-1b"
    tags = {
        Name = "manoj"
    }

  
#   lifecycle {
#     ignore_changes = [tags]
#   }
# lifecycle {
#   create_before_destroy = true
# }

lifecycle {
   prevent_destroy = true
}
}
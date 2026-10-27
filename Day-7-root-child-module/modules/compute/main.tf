resource "aws_instance" "name" {
    ami           = var.ami
    instance_type = var.instance_type
    subnet_id     = var.subnet_id
  
}
output ami_id {
    value = aws_instance.name.ami
}
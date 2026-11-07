
resource "aws_security_group" "devops-project-manoj-testing" {
  name        = "devops-project-manoj-testing"
  description = "Allow inbound traffic from different CIDRs"

  ingress = [
    for rule in [
      {
        port        = 22
        description = "SSH access"
        cidrs       = ["183.82.125.5/32"]
      },
      {
        port        = 80
        description = "HTTP access"
        cidrs       = ["0.0.0.0/0"]
      },
      {
        port        = 443
        description = "HTTPS access"
        cidrs       = ["0.0.0.0/0"]
      },
      {
        port        = 8080
        description = "Jenkins access"
        cidrs       = ["183.82.125.5/32"]
      },
      {
        port        = 3306
        description = "MySQL access"
        cidrs       = ["10.0.0.0/16"]
      },
      {
        port        = 3000
        description = "Grafana access"
        cidrs       = ["10.0.1.0/24"]
      }
    ] : {
      description      = rule.description
      from_port        = rule.port
      to_port          = rule.port
      protocol         = "tcp"
      cidr_blocks      = rule.cidrs
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-project-manoj-testing"
  }
}

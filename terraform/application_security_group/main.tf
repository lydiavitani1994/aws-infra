resource "aws_security_group" "application" {
  name        = var.tag_name
  description = var.description
  vpc_id      = var.vpc_id

  ingress {
    description      = "443 TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["${var.vpc_cidr_block}"]
  }
  ingress{
    description      = "22 TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${var.vpc_cidr_block}"]
  }
  
  ingress {
    description      = "80 TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["${var.vpc_cidr_block}"]
  }

  ingress  {
    description      = "8080 TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # egress {
  #   description      = "443 TLS from VPC"
  #   from_port        = 443
  #   to_port          = 443
  #   protocol         = "tcp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   # ipv6_cidr_blocks = []
  #   # prefix_list_ids = []
  #   # security_groups = []
  #   # self = false
  # }
  # egress {
  #   description      = "80 TLS from VPC"
  #   from_port        = 80
  #   to_port          = 80
  #   protocol         = "tcp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   # ipv6_cidr_blocks = []
  #   # prefix_list_ids = []
  #   # security_groups = []
  #   # self = false
  # }


  # egress  {
  #   description      = "8080 TLS from VPC"
  #   from_port        = 5432
  #   to_port          = 5432
  #   protocol         = "tcp"
  #   # security_groups = ["${var.des_security_group_id}"]
  #   # cidr_blocks      = ["0.0.0.0/0"]
  #   # ipv6_cidr_blocks = []
  #   # prefix_list_ids = []
  #   # security_groups = []
  #   # self = false
  # }

  tags = {
    Name = var.tag_name
  }
}
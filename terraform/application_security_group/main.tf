resource "aws_security_group" "application" {
  name        = var.tag_name
  description = var.description
  vpc_id      = var.vpc_id

  ingress  = [
    {
        description      = "443 TLS from VPC"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["${var.vpc_cidr_block}"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false
    }, 
    {
        description      = "22 TLS from VPC"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["${var.vpc_cidr_block}"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false
    }, 
    {
        description      = "80 TLS from VPC"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["${var.vpc_cidr_block}"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false
    }, 
    {
        description      = "8080 TLS from VPC"
        from_port        = 8080
        to_port          = 8080
        protocol         = "tcp"
        cidr_blocks      = ["${var.vpc_cidr_block}"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false
    },
  ]

  tags = {
    Name = var.tag_name
  }
}
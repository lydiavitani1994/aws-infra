resource "aws_security_group" "database" {
  name        = var.tag_name
  description = var.description
  vpc_id      = var.vpc_id

  ingress  = [
    {
        description      = "5432 TLS from VPC"
        from_port        = 5432
        to_port          = 5432
        protocol         = "tcp"
        cidr_blocks      = []
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = ["${var.source_security_group_id}"]
        self = false
    }, 
  ]

  tags = {
    Name = var.tag_name
  }
}
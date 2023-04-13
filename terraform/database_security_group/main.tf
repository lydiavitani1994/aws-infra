resource "aws_security_group" "database" {
  name        = var.tag_name
  description = var.description
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    # cidr_blocks      = ["${var.vpc_cidr_block}"]
    security_groups = ["${var.source_security_group_id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # security_groups = ["${var.source_security_group_id}"]
  }

  tags = {
    Name = var.tag_name
  }
}
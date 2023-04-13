resource "aws_security_group" "load_balancer" {
  name        = var.tag_name
  description = var.description
  vpc_id      = var.vpc_id

  # ingress {
  #   from_port        = 80
  #   to_port          = 80
  #   protocol         = "tcp"
  #   cidr_blocks      = ["${var.vpc_cidr_block}"]
  # }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["${var.vpc_cidr_block}"]
    # security_groups = ["${var.destination_security_group_id}"]
  }

  tags = {
    Name = var.tag_name
  }
}
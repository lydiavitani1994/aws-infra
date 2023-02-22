data "aws_ami" "aws_linux_2" {
  most_recent = var.filter_most_recent

  filter {
    name   = "name"
    values = [var.filter_name_value]
  }

  filter {
    name   = "root-device-type"
    values = [var.filter_device_type_value]
  }

  filter {
    name   = "virtualization-type"
    values = [var.filter_virtualization_type_value]
  }
}

resource "aws_instance" "instance" {
  key_name = "ec2"
  ami           = data.aws_ami.aws_linux_2.id
  instance_type = var.instance_type
  disable_api_termination = var.disable_api_termination
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.public_subnet_ids[0]
  associate_public_ip_address = var.associate_public_ip_address

  # root disk
  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
  }

  tags = {
    Name = var.tag_name
  }
}


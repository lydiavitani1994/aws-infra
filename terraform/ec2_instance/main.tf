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
  iam_instance_profile = var.iam_instance_profile

  # root disk
  root_block_device {
    delete_on_termination = var.delete_on_termination
    volume_size           = var.volume_size
    volume_type           = var.volume_type
  }

  user_data = <<-EOF
              #!/bin/bash
              chmod +x /etc/environment
              echo "#!/bin/sh" > /etc/environment
              echo "DB_USERNAME=${var.db_username}" >> /etc/environment
              echo "DB_PASSWORD=${var.db_password}" >> /etc/environment
              echo "DB_HOSTNAME=${var.db_hostname}" >> /etc/environment
              echo "S3_BUCKET_NAME=${var.s3_bucket_name}" >> /etc/environment
              sudo source /etc/environment
              EOF
# 
# # sudo chmod 777 -R /etc/profile.d
              # cd /etc/profile.d
              # touch db_setenv.sh             
#/bin/bash /etc/profile.d/db_setenv.sh start
  # user_data     = <<-EOF
  #   #cloud-config
  #   write_files:
  #     - path: /etc/profile.d/my-env-vars.sh
  #       permissions: '0755'
  #       owner: root
  #       content: |
  #         #!/bin/bash
  #         export DB_USERNAME=${var.db_username}
  #         export DB_PASSWORD=${var.db_password}
  #         export DB_HOSTNAME=${var.db_hostname}
  #         export S3_BUCKET_NAME=${var.s3_bucket_name}
  # EOF
              
  tags = {
    Name = var.tag_name
  }
}


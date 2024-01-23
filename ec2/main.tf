######################################
## EC2

# public server
resource "aws_instance" "public" {
  key_name                = var.key_name
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = var.ec2_type_public
  vpc_security_group_ids  = [var.security_group_id_public]
  subnet_id               = var.pub_sub_ids[0]
  disable_api_termination = var.instance_disable_termination

  user_data = file("${path.module}/user_data/user_data_public.sh")

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = merge(
    {
      Name = format(
        "%s-public-server",
        var.name
      )
    },
    var.tags,
  )
}


resource "aws_instance" "public1" {
  key_name                = var.key_name
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = var.ec2_type_public
  vpc_security_group_ids  = [var.security_group_id_public]
  subnet_id               = var.pub_sub_ids[0]
  disable_api_termination = var.instance_disable_termination

  user_data = file("${path.module}/user_data/user_data_public.sh")

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = merge(
    {
      Name = format(
        "%s-public-server2",
        var.name
      )
    },
    var.tags,
  )
}
# private server
#resource "aws_instance" "private" {
#  key_name               = var.key_name
#  ami                    = data.aws_ami.amazon_linux2_kernel_5.id
#  instance_type          = var.ec2_type_private
#  vpc_security_group_ids = [var.security_group_id_private]
#  subnet_id              = var.pri_sub_ids[0]
#
#  iam_instance_profile    = var.iam_instance_profile
#  disable_api_termination = var.instance_disable_termination
#
#  user_data = file("${path.module}/user_data/user_data_private.sh")
#
#  root_block_device {
#    volume_size           = 10
#    volume_type           = "gp3"
#    delete_on_termination = true
#  }
#
#  tags = merge(
#    {
#      Name = format(
#        "%s-private-server",
#        var.name
#      )
#    },
#    var.tags,
#  )
#}


######################################
## EIP

# public_eip
resource "aws_eip" "public" {
  #vpc      = true
  domain    = "vpc"
  instance = aws_instance.public.id

  tags = merge(
    {
      Name = format(
        "%s-public-eip-%s",
        var.name,
        element(split("-", var.az_names[0]), 2)
      )
    },
    var.tags,
  )
}


######################################
## Auto Scaling Group(ASG) setting

# Launch Configuration
resource "aws_launch_configuration" "jsp_config" {
  name_prefix     = "jsp-lauchconfig-"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.ec2_type_public
  security_groups = [var.security_group_id_public]

  user_data = file("${path.module}/user_data/user_data_public.sh")

  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    delete_on_termination = true
  }

  # Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "jsp_alb" {
  name                 = format("%s-%s-asg", var.name, terraform.workspace)
  launch_configuration = aws_launch_configuration.jsp_config.name
  vpc_zone_identifier  = [var.pub_sub_ids[0], var.pub_sub_ids[1]]
  min_size = 2
  max_size = 10

  tag {
    key              = "Name"
    value            = format("%s-%s-alb", var.name, terraform.workspace)
    propagate_at_launch = true
  }
}

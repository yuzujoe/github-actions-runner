resource "aws_launch_template" "this" {
  name = var.name

  instance_type = "t2.micro"
  # describe latest ami
  # aws ec2 describe-images --region ap-northeast-1 --query 'reverse(sort_by(Images, &CreationDate))[:1]' --owners amazon --filters 'Name=name,Values=amzn2-ami-hvm-2.0.*-x86_64-gp2' --output table
  image_id      = "ami-0f27d081df46f326c"

  instance_market_options {
    market_type = "spot"
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      volume_size           = 30
      volume_type           = "gp2"
    }
  }
}

resource "aws_security_group" "this" {
  name = var.name

  vpc_id = "example"

  tags = {
    Name = var.name
  }
}

resource "aws_security_group_rule" "egress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.this.id
  to_port           = 0
  type              = "egress"
}

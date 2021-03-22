resource "aws_autoscaling_group" "this" {
  name = var.name

  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 0
  termination_policies      = ["OldestInstance"]
  vpc_zone_identifier = [
    # Please set your subnet
  ]

  tag {
    key                 = "Name"
    propagate_at_launch = false
    value               = var.name
  }
}

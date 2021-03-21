resource "aws_iam_instance_profile" "this" {
  name = var.name
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "secret_manager_read_only" {
  name   = "${var.name}-secret-manager-read-only"
  policy = data.aws_iam_policy_document.secret_manager_read_only.json
  role   = aws_iam_role.this.id
}

data "aws_iam_policy_document" "secret_manager_read_only" {
  statement {
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:secretsmanager:<your-region>:<your-account>:secret:*"
    ]
  }
}

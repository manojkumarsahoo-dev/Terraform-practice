# ------------------------------------------------------------------------------
# 1. IAM User Configuration
# ------------------------------------------------------------------------------
resource "aws_iam_user" "day6_user" {
  name = "day6-app-user"

  tags = {
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

# ------------------------------------------------------------------------------
# 2. IAM Role Configuration (with Trust Policy for EC2)
# ------------------------------------------------------------------------------
# Define the trust relationship allowing EC2 instances to assume this role
data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "day6_role" {
  name               = "day6-ec2-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

  tags = {
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

# ------------------------------------------------------------------------------
# 3. Custom IAM Policy & Policy Attachments
# ------------------------------------------------------------------------------
# Custom Policy document granting read-only access to S3
data "aws_iam_policy_document" "s3_read_policy_doc" {
  statement {
    actions   = ["s3:Get*", "s3:List*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "day6_policy" {
  name        = "day6-s3-read-only-policy"
  description = "Allows read-only access to S3 buckets"
  policy      = data.aws_iam_policy_document.s3_read_policy_doc.json
}

# Attach the policy to the IAM User
resource "aws_iam_user_policy_attachment" "user_policy_attach" {
  user       = aws_iam_user.day6_user.name
  policy_arn = aws_iam_policy.day6_policy.arn
}

# Attach the policy to the IAM Role
resource "aws_iam_role_policy_attachment" "role_policy_attach" {
  role       = aws_iam_role.day6_role.name
  policy_arn = aws_iam_policy.day6_policy.arn
}
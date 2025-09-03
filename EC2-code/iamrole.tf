# IAM Role
resource "aws_iam_role" "demo_role" {
  name = "test1_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#IAM Policy
resource "aws_iam_policy" "demo_policy" {
  name        = "test2_policy"
  path        = "/"
  description = "My test policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# IAM Policy Attachment to role
resource "aws_iam_role_policy_attachment" "role_policy_attach" {
  role       = aws_iam_role.demo_role.name
  policy_arn = aws_iam_policy.demo_policy.arn
}

# IAM role Attachment to instance
resource "aws_iam_instance_profile" "demo_role_profile" {
  name = "demo-instance-profile"
  role = aws_iam_role.demo_role.name
}
# Creating a Group
resource "aws_iam_group" "group" {
  name = "${var.group_name}"
}

# Creating multiple users
resource "aws_iam_user" "users" {
  count = length(var.given_user)
  name  = var.given_user[count.index]
}

# Adding the users to the group
resource "aws_iam_group_membership" "users_group" {
  name  = "${var.group_name}-group-membership"
  count = length(var.given_user)
  users = [aws_iam_user.users[count.index].name]
  group = aws_iam_group.group.name
}

# Fetch existing AWS-managed policies
data "aws_iam_policy" "selected" {
  for_each = toset(var.policy_names) // 'for_each' will loop the block and 'toset()' will conver the list(["",""..])--  
  name     = each.value             // --we gave in the main volume into a set(["",""..]).
}

# IAM Policy Attachment to Group
resource "aws_iam_group_policy_attachment" "lb_ro" {
  for_each   = data.aws_iam_policy.selected
  group      = aws_iam_group.group.name
  policy_arn = each.value.arn
}
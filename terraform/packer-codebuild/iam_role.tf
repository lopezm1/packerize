data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


#--------------------------------------------------------------
# Packerize IAM Role
#--------------------------------------------------------------

resource "aws_iam_role" "packerize_service_role" {
  name = "PackerizeServiceRole"
  path = "/terraform/"

  assume_role_policy = "${data.aws_iam_policy_document.codebuild_assume_role_policy.json}"
}

# Trusted Entities that can assume Role
data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

# Attach policies
resource "aws_iam_role_policy" "codebuild_access_policy" {
  name = "CodeBuildPolicy"
  role = "${aws_iam_role.packerize_service_role.id}"

  policy = "${data.aws_iam_policy_document.code_build_access_document.json}"
}

#--------------------------------------------------------------
# Packerize Policy Document
#--------------------------------------------------------------

data "aws_iam_policy_document" "code_build_access_document" {
  statement {
    sid = "CodeBuildToCWL"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.packerize_codebuild.name}",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.packerize_codebuild.name}:*",
    ]
  }
}
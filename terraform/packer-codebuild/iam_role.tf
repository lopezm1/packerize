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
      "logs:DeleteLogGroup",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.packer_codebuild}",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.packer_codebuild}:*",
    ]
  }

  statement {
    sid = "CodeBuildToLogs"

    actions = [
      "logs:DescribeLogGroups",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group::log-stream:*",
    ]
  }

  statement {
    sid = "CodeBuildToVPC"

    actions = [
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CopyImage",
      "ec2:CreateImage",
      "ec2:CreateKeypair",
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteKeyPair",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSnapshot",
      "ec2:DeleteVolume",
      "ec2:DeregisterImage",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeImageAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRegions",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVpcs",
      "ec2:DetachVolume",
      "ec2:GetPasswordData",
      "ec2:ModifyImageAttribute",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifySnapshotAttribute",
      "ec2:RegisterImage",
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "CodeBuildToCloudWatch"

    actions = [
      "events:PutEvents",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "CodeBuildToSSM"

    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${lookup(var.env, data.aws_caller_identity.current.account_id)}/*",
    ]
  }

  statement {
    sid = "CodeBuildIAM"

    actions = [
      "iam:PassRole",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "CodeBuildToS3"

    actions = [
      "s3:PutObject",
      "s3:GetBucketVersioning",
      "s3:GetObjectVersion",
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.packerize_bucket.arn}",
      "${aws_s3_bucket.packerize_bucket.arn}/*"
    ]
  }
}

# IAM Role for AppStream Image Builder
resource "aws_iam_role" "appstream_image_builder_role" {
  name = "AppStream_ImageBuilder_Role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "appstream.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy to allow AppStream and EC2 actions
resource "aws_iam_policy" "appstream_image_builder_policy" {
  name        = "AppStreamImageBuilderPolicy"
  description = "Policy for AppStream Image Builder with access to EC2, CloudWatch, and S3 if needed"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "appstream:*",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "cloudwatch:*",
          "logs:*"
        ],
        "Resource": "*"
      }
    ]
  })
}

# Attach the policy to the IAM Role
resource "aws_iam_role_policy_attachment" "appstream_image_builder_role_attach" {
  role       = aws_iam_role.appstream_image_builder_role.name
  policy_arn = aws_iam_policy.appstream_image_builder_policy.arn
}




resource "aws_appstream_image_builder" "test_fleet" {
  name                           = "test_imagebuilder"
  description                    = "Description of a ImageBuilder"
  display_name                   = "Display name of a ImageBuilder"
  enable_default_internet_access = true
  image_name                     = "AppStream-WinServer2019-06-17-2024"
  instance_type                  = "stream.standard.large"

  vpc_config {
    subnet_ids = [ "subnet-067867484a74142ef"]
    security_group_ids = ["sg-00869fd5461cae604"]
  }


  iam_role_arn = aws_iam_role.appstream_image_builder_role.arn
  tags = {
    Name = "test Image Builder"
  }

  
}
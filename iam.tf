resource "aws_iam_instance_profile" "opsworks_instance" {
  name  = "opsworks_instance"
  roles = ["${aws_iam_role.aws-opsworks-prod-ec2-role-ire.name}"]
}

resource "aws_iam_role" "aws-opsworks-prod-ec2-role-ire" {
  name               = "aws-opsworks-prod-ec2-role-ire"
  path               = "/"
  assume_role_policy = "${file("policies/aws-opsworks-prod-ec2-role-ire.json")}"
}

resource "aws_iam_role" "aws-opsworks-service-role-ire" {
  name               = "aws-opsworks-service-role-ire"
  path               = "/"
  assume_role_policy = "${file("policies/aws-opsworks-service-role-ire.json")}"
}

resource "aws_iam_role_policy" "aws-service-policy-route53-ire" {
  name   = "aws-service-policy-route53-ire"
  role   = "${aws_iam_role.aws-opsworks-prod-ec2-role-ire.id}"
  policy = "${file("policies/aws-service-policy-route53.json")}"
}

resource "aws_iam_role_policy" "service-policy-s3-ire" {
  name   = "service-policy-s3-ire"
  role   = "${aws_iam_role.aws-opsworks-prod-ec2-role-ire.id}"
  policy = "${file("policies/service-policy-s3.json")}"
}

resource "aws_iam_role_policy" "aws-service-policies-ire" {
  name   = "aws-service-policies-ire"
  role   = "${aws_iam_role.aws-opsworks-prod-ec2-role-ire.id}"
  policy = "${file("policies/aws-service-policies.json")}"
}

resource "aws_iam_role_policy" "aws-opsworks-service-policies-ire" {
  name   = "aws-opsworks-service-policies-ire"
  role   = "${aws_iam_role.aws-opsworks-service-role-ire.id}"
  policy = "${file("policies/aws-opsworks-service-role.json")}"
}

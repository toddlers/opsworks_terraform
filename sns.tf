resource "aws_sns_topic" "olacabs-elasticache" {
  name         = "olacabs-elasticache"
  display_name = "olacabs elasticache SNS topic"
}

resource "aws_sns_topic_policy" "elasticache-sns-policy" {
  arn = "${aws_sns_topic.olacabs-elasticache.arn}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "default",
  "Statement":[{
    "Sid": "default",
    "Effect": "Allow",
    "Principal": {"AWS":"*"},
    "Action": [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic"
    ],
    "Resource": "${aws_sns_topic.olacabs-elasticache.arn}"
  }]
}
POLICY
}

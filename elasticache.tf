#
# Security group resources
#
resource "aws_security_group" "redis" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "sgCacheCluster"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_elasticache_subnet_group" "rails_app_ec" {
  name = "rails-app-ec"

  #subnet_ids = "${aws_subnet.main-rds-private-1.id}"
  subnet_ids = ["${aws_subnet.main-rds-private-1.id}", "${aws_subnet.main-rds-private-2.id}", "${aws_subnet.main-rds-private-3.id}"]
}

/* resource "aws_elasticache_cluster" "rails_app_replication" { */
/*   cluster_id           = "rails-01" */
/*   engine               = "redis" */
/*   node_type            = "${var.instance_type}" */
/*   port                 = 6379 */
/*   num_cache_nodes      = 1 */
/*   parameter_group_name = "${var.parameter_group}" */
/*   security_group_ids   = ["${aws_security_group.redis.id}"] */
/*   subnet_group_name    = "${aws_elasticache_subnet_group.rails_app_ec.name}" */
/*   engine_version       = "${var.engine_version_ec}" */
/* } */

#
# ElastiCache resources
#
resource "aws_elasticache_replication_group" "rails_app_replication" {
  #depends_on                    = ["aws_elasticache_cluster.rails_app_replication"]
  replication_group_id          = "rails-01"
  replication_group_description = "Replication group for Redis"
  automatic_failover_enabled    = "${var.automatic_failover_enabled}"
  number_cache_clusters         = "${var.desired_clusters}"
  node_type                     = "${var.instance_type}"
  engine_version                = "${var.engine_version_ec}"
  parameter_group_name          = "${var.parameter_group}"
  subnet_group_name             = "${aws_elasticache_subnet_group.rails_app_ec.name}"
  security_group_ids            = ["${aws_security_group.redis.id}"]
  notification_topic_arn        = "${aws_sns_topic.olacabs-elasticache.arn}"
  port                          = "6379"

  tags {
    Name        = "CacheReplicationGroup"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

#
# CloudWatch resources
#
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  #depends_on = ["aws_elasticache_replication_group.rails_app_replication"]
  count = "${var.desired_clusters}"

  alarm_name          = "alarm${var.environment}CacheCluster00${count.index + 1}CPUUtilization"
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = "${var.alarm_cpu_threshold}"

  dimensions {
    CacheClusterId = "${aws_elasticache_replication_group.rails_app_replication.id}-00${count.index + 1}"
  }

  alarm_actions = ["${aws_sns_topic_policy.elasticache-sns-policy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  depends_on = ["aws_elasticache_replication_group.rails_app_replication"]
  count      = "${var.desired_clusters}"

  alarm_name          = "alarm${var.environment}CacheCluster00${count.index + 1}FreeableMemory"
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  threshold = "${var.alarm_memory_threshold}"

  dimensions {
    CacheClusterId = "${aws_elasticache_replication_group.rails_app_replication.id}-00${count.index + 1}"
  }

  alarm_actions = ["${aws_sns_topic_policy.elasticache-sns-policy.arn}"]
}

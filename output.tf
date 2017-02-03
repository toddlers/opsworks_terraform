output "awesomeapp-opsworks-stack-name" {
  value = "${aws_opsworks_stack.main.id}"
}

output "ec2-instance-private-ip" {
  value = "${aws_opsworks_instance.awesomeapp01.private_ip}"
}

output "elb_dns_name" {
  value = "${aws_elb.prod-awesomeapp.dns_name}"
}

output "subnet_group" {
  value = "${aws_db_subnet_group.main_rds_subnet.name}"
}

output "db_instance_id" {
  value = "${aws_db_instance.rails_app_rds.id}"
}

output "db_instance_address" {
  value = "${aws_db_instance.rails_app_rds.address}"
}

output "id" {
  value = "${aws_elasticache_replication_group.rails_app_replication.id}"
}

output "cache_security_group_id" {
  value = "${aws_security_group.redis.id}"
}

output "port" {
  value = "6379"
}

output "endpoint" {
  value = "${aws_elasticache_replication_group.rails_app_replication.primary_endpoint_address}"
}

resource "aws_db_instance" "rails_app_rds" {
  depends_on             = ["aws_security_group.rds_rails_app"]
  identifier             = "${var.identifier}"
  allocated_storage      = "${var.storage}"
  engine                 = "${var.engine}"
  engine_version         = "${lookup(var.engine_version, var.engine)}"
  instance_class         = "${var.instance_class}"
  name                   = "${var.db_name}"
  username               = "${var.username}"
  password               = "${var.password}"
  vpc_security_group_ids = ["${aws_security_group.rds_rails_app.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.main_rds_subnet.id}"
}

resource "aws_db_subnet_group" "main_rds_subnet" {
  name        = "main_rds_subnet"
  description = "Our main subnets for rds"
  subnet_ids  = ["${aws_subnet.main-rds-private-1.id}", "${aws_subnet.main-rds-private-2.id}", "${aws_subnet.main-rds-private-3.id}"]
}

resource "aws_opsworks_rds_db_instance" "rails_app_rds" {
  stack_id            = "${aws_opsworks_stack.main.id}"
  rds_db_instance_arn = "${aws_db_instance.rails_app_rds.arn}"
  db_user             = "${var.username}"
  db_password         = "${var.password}"
}

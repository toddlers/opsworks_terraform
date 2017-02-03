resource "aws_elb" "prod-awesomeapp" {
  name = "prod-awesomeapp"

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    target              = "TCP:3000"
    interval            = 60
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  subnets         = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}", "${aws_subnet.main-public-3.id}"]
  security_groups = ["${aws_security_group.load_balancers.id}"]

  tags {
    Name = "prod-awesomeapp"
  }
}

resource "aws_opsworks_stack" "main" {
  name                          = "awesomeapp"
  region                        = "${var.region}"
  default_ssh_key_name          = "${var.ssh_key_name}"
  default_root_device_type      = "ebs"
  use_custom_cookbooks          = true
  vpc_id                        = "${aws_vpc.main.id}"
  hostname_theme                = "Layer_Dependent"
  manage_berkshelf              = false
  default_availability_zone     = "${var.default_availability_zone}"
  configuration_manager_version = "11.10"
  configuration_manager_name    = "Chef"
  default_subnet_id             = "${aws_subnet.main-private-1.id}"
  use_opsworks_security_groups  = false

  custom_cookbooks_source = {
    type = "s3"
    url  = "https://s3.amazonaws.com/some-bucket/some-file.tar.gz"
  }

  service_role_arn             = "${aws_iam_role.aws-opsworks-service-role-ire.arn}"
  default_instance_profile_arn = "${aws_iam_instance_profile.opsworks_instance.arn}"

  custom_json = "${file("custom_json/custom_json.json")}"
}

resource "aws_opsworks_rails_app_layer" "app" {
  stack_id                  = "${aws_opsworks_stack.main.id}"
  name                      = "awesomeapp"
  ruby_version              = "2.3"
  custom_setup_recipes      = "${var.default_cookbooks_list}"
  auto_healing              = false
  custom_security_group_ids = ["${aws_security_group.rails_app.id}"]
  elastic_load_balancer     = "${aws_elb.prod-awesomeapp.name}"
}

resource "aws_opsworks_application" "awesomeapp" {
  name                      = "awesomeapi"
  short_name                = "awesomeapi"
  stack_id                  = "${aws_opsworks_stack.main.id}"
  type                      = "rails"
  data_source_type          = "RdsDbInstance"
  data_source_arn           = "${aws_db_instance.rails_app_rds.arn}"
  data_source_database_name = "${var.db_name}"
  description               = "Awesome API Ticks"

  domains = [
    "olacabs.com",
  ]

  environment = {
    key    = "REDIS_PUBLISH_URL"
    value  = "${aws_elasticache_replication_group.rails_app_replication.primary_endpoint_address}:6379"
    secure = false
  }

  environment = {
    key    = "DATABASE_URL"
    value  = "${aws_db_instance.rails_app_rds.endpoint}"
    secure = false
  }

  app_source = {
    type = "s3"
    url  = "https://s3-ap-southeast-1.amazonaws.com/olacabs-release/awesomeapi/awesomeapi.0.0.1.tar.gz"
  }

  document_root         = "public"
  auto_bundle_on_deploy = true
  rails_env             = "production"
}

resource "aws_opsworks_instance" "awesomeapp01" {
  stack_id = "${aws_opsworks_stack.main.id}"

  layer_ids = [
    "${aws_opsworks_rails_app_layer.app.id}",
  ]

  instance_type     = "${var.default_instance_type}"
  os                = "Custom"
  state             = "stopped"
  availability_zone = "${var.default_availability_zone}"
  ami_id            = "${var.default_ami_id}"
}

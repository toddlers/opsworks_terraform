variable "access_key" {
  description = " The AWS access key"
  default     = "<access_key>"
}

variable "secret_key" {
  description = "The AWS secret key"
  default     = "<secret_key>"
}

variable "ssh_key_name" {
  description = "default ssh key name"
  default     = "<ssh_key_name>"
}

variable "region" {
  type        = "string"
  description = "The AWS region"
  default     = "eu-west-1"
}

variable "default_ami_id" {
  description = "ami id for instance"
  default     = "ami-11b2dd62"
}

variable "default_instance_type" {
  description = "instace type"
  default     = "t2.micro"
}

variable "default_availability_zone" {
  description = "default_availability_zone name"
  default     = "eu-west-1a"
}

variable "default_cookbooks_list" {
  type        = "list"
  description = "list of default cookbooks"
  default     = ["timezone-ii", "opsworks_route53", "opsworks_hostname", "opsworks_resolvconf"]
}

# rds variables

variable "identifier" {
  default     = "mydb-rds"
  description = "Identifier for your DB"
}

variable "storage" {
  default     = "10"
  description = "Storage size in GB"
}

variable "engine" {
  default     = "postgres"
  description = "Engine type, example values mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"

  default = {
    mysql    = "5.6.22"
    postgres = "9.4.1"
  }
}

variable "instance_class" {
  default     = "db.t2.micro"
  description = "Instance class"
}

variable "db_name" {
  default     = "awesomeapi"
  description = "db name"
}

variable "username" {
  default     = "myuser"
  description = "User name"
}

variable "password" {
  description = "password, provide through your ENV variables"
  default     = "sureshptest"
}

# elasticache variables

variable "project" {
  default = "olacabs"
}

variable "environment" {
  default = "production"
}

variable "parameter_group" {
  default = "default.redis3.2"
}

variable "desired_clusters" {
  default = "1"
}

variable "instance_type" {
  default = "cache.t2.micro"
}

variable "engine_version_ec" {
  default = "3.2.4"
}

variable "automatic_failover_enabled" {
  default = false
}

variable "alarm_cpu_threshold" {
  default = "75"
}

variable "alarm_memory_threshold" {
  # 10MB
  default = "10000000"
}

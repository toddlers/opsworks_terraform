# opsworks_terraform
OpsWorks rails app automating using terraform

## Following things it will do

  1. A VPC with necessary networking in place like NAT Gateway with respective subnets 
  2. An OpsWorks stack with app and necessary SG including ELB
  3. RDS and attach it to OpsWorks stack
  4. ElastiCache Cluster with SNS topic for alerting
  5. Necessary policies for OpsWorks and other components


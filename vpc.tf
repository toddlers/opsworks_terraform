# Internet VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags {
    Name = "main"
  }
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "main"
  }
}

# route tables
resource "aws_route_table" "main-public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-gw.id}"
  }

  tags {
    Name = "main-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = "${aws_subnet.main-public-1.id}"
  route_table_id = "${aws_route_table.main-public.id}"
}

resource "aws_route_table_association" "main-public-2-a" {
  subnet_id      = "${aws_subnet.main-public-2.id}"
  route_table_id = "${aws_route_table.main-public.id}"
}

resource "aws_route_table_association" "main-public-3-a" {
  subnet_id      = "${aws_subnet.main-public-3.id}"
  route_table_id = "${aws_route_table.main-public.id}"
}

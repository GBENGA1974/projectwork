# create vpc

resource "aws_vpc" "webserver_vpc" {
  cidr_block       = var.cidr_block[0]
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true


  tags = {
    Name = "webserver1_vpc"
  }
}

# PUBLIC SUBNET1

resource "aws_subnet" "webserver_public_subnet1" {
  vpc_id     = aws_vpc.webserver_vpc.id
  cidr_block = var.cidr_block[1]
  map_public_ip_on_launch = true
  availability_zone = "eu-west-2a"


  tags = {
    Name = "webserver1_public_subnet1"
  }
}

# PUBLIC SUBNET2

resource "aws_subnet" "webserver_public_subnet2" {
  vpc_id     = aws_vpc.webserver_vpc.id
  cidr_block = var.cidr_block[2]
  map_public_ip_on_launch = true
  availability_zone = "eu-west-2b"


  tags = {
    Name = "webserver1_public_subnet2"
  }
}

# PRIVATE SUBNET1 for network_application

resource "aws_subnet" "application-private_subnet1" {
  vpc_id     = aws_vpc.webserver_vpc.id
  cidr_block = var.cidr_block[3]
  map_public_ip_on_launch = false
  availability_zone = "eu-west-2c"


  tags = {
    Name = "application-private_subnet1"
  }
}

# PRIVATE SUBNET2 for networking_application

resource "aws_subnet" "application-private_subnet2" {
  vpc_id     = aws_vpc.webserver_vpc.id
  cidr_block = var.cidr_block[4]
  map_public_ip_on_launch = false
  availability_zone = "eu-west-2a"


  tags = {
    Name = "application-private_subnet2"
  }
}

# PRIVATE SUBNET1 for database

resource "aws_subnet" "database_private_subnet1" {
  vpc_id     = aws_vpc.webserver_vpc.id
  cidr_block = var.cidr_block[5]
  map_public_ip_on_launch = false
  availability_zone = "eu-west-2b"


  tags = {
    Name = "database_private_subnet1"
  }
}

# PRIVATE SUBNET2 for database

resource "aws_subnet" "database_private_subnet2" {
  vpc_id     = aws_vpc.webserver_vpc.id
  cidr_block = var.cidr_block[6]
  map_public_ip_on_launch = false
  availability_zone = "eu-west-2c"


  tags = {
    Name = "database_private_subnet2"
  }
}
# PUBLIC ROUTE TABLE

resource "aws_route_table" "web_public_route_table" {
  vpc_id = aws_vpc.webserver_vpc.id

  tags = {
    Name = "web_public_route_table"
  }
}

# PRIVATE ROUTE TABLE

resource "aws_route_table" "app_data_private_route_table" {
  vpc_id = aws_vpc.webserver_vpc.id

  tags = {
    Name = "app_data_private_route_table"
  }
}

# INTERNET GATEWAY

resource "aws_internet_gateway" "webserver-igw" {
  vpc_id = aws_vpc.webserver_vpc.id

  tags = {
    Name = "webserver-igw"
  }
}

# IGW ASSOCIATION WITH ROUTE TABLE

resource "aws_route" "Association_public-RT" {
  route_table_id            = aws_route_table.web_public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.webserver-igw.id
}

# ASSOCIATE PUBLIC SUBNET1 and 2 TO PUBLIC ROUTE(webserver)

resource "aws_route_table_association" "project1-PUBSUB1-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.webserver_public_subnet1.id
  route_table_id = aws_route_table.web_public_route_table.id
}

resource "aws_route_table_association" "project1-PUBSUB2-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.webserver_public_subnet2.id
  route_table_id = aws_route_table.web_public_route_table.id
}

# ASSOCIATE PRIVATE SUBNETS1 and TO PRIVATE ROUTE (application)

resource "aws_route_table_association" "project1-PRIVSUB1-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.application-private_subnet1.id
  route_table_id = aws_route_table.app_data_private_route_table.id
}

resource "aws_route_table_association" "project1-PRIVSUB2-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.application-private_subnet2.id
  route_table_id = aws_route_table.app_data_private_route_table.id
}

# ASSOCIATE PRIVATE SUBNETS TO PRIVATE ROUTE (database)

resource "aws_route_table_association" "project1-PRIVSUB3-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.database-private_subnet1.id
  route_table_id = aws_route_table.app_data_private_route_table.id
}

resource "aws_route_table_association" "project1-PRIVSUB4-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.database-private_subnet2.id
  route_table_id = aws_route_table.app_data_private_route_table.id
}
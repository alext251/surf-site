resource "aws_subnet" "app_subnet_0" {
  availability_zone = "us-west-2a"
  cidr_block = "10.0.0.0/22"
  map_public_ip_on_launch = false

  tags = {
    Name = "app_subnet_0_surf_site"
    SubnetType = "Private"
  }

  vpc_id = aws_vpc.surf_private_network.id
}

resource "aws_subnet" "app_subnet_1" {
  availability_zone = "us-west-2b"
  cidr_block = "10.0.4.0/22"
  map_public_ip_on_launch = false

  tags = {
    Name = "app_subnet_1_surf_site"
    SubnetType = "Private"
  }

  vpc_id = aws_vpc.surf_private_network.id
}

resource "aws_route_table_association" "app_subnet_route_table_association_0" {
  route_table_id = aws_route_table.nat_route_table_0.id
  subnet_id = aws_subnet.app_subnet_0.id
}

resource "aws_route_table_association" "app_subnet_route_table_association_1" {
  route_table_id = aws_route_table.nat_route_table_1.id
  subnet_id = aws_subnet.app_subnet_1.id
}

resource "aws_subnet" "data_subnet_0" {
  availability_zone = "us-west-2a"
  cidr_block = "10.0.100.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "surf_site_data_subnet_0"
    SubnetType = "Private"
  }

  vpc_id = aws_vpc.surf_private_network.id
}

resource "aws_subnet" "data_subnet_1" {
  availability_zone = "us-west-2b"
  cidr_block = "10.0.101.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "surf_site_data_subnet_1"
    SubnetType = "Private" 
  }
  
  vpc_id = aws_vpc.surf_private_network.id
}

resource "aws_route_table_association" "data_subnet_route_table_association_0" {
  route_table_id = aws_route_table.nat_route_table_0.id
  subnet_id = aws_subnet.data_subnet_0.id
}

resource "aws_route_table_association" "data_subnet_route_table_association_1" {
  route_table_id = aws_route_table.nat_route_table_1.id
  subnet_id = aws_subnet.data_subnet_1.id
}

resource "aws_internet_gateway" "surf_internet_gateway" {
  tags = {
    Name = "surf_site_internet_gateway"
  }
}

resource "aws_internet_gateway_attachment" "surf_attach_internet_gateway" {
  internet_gateway_id = aws_internet_gateway.surf_internet_gateway.id
  vpc_id = aws_vpc.surf_private_network.id
}

resource "aws_eip" "nat_eip_0" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway_0" {
  allocation_id = aws_eip.nat_eip_0.allocation_id
  subnet_id =  aws_subnet.public_subnet_0.id
}

resource "aws_route" "nat_route_0" {
  route_table_id = aws_route_table.nat_route_table_0.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway_0.id
}

resource "aws_route_table" "nat_route_table_0" {
  tags = {
    Name = "surf_site_nat_route_table_0",
    Network = "Public"
  }
  vpc_id = aws_vpc.surf_private_network.id
}

resource "aws_eip" "nat_eip_1" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_eip_1.allocation_id
  subnet_id = aws_subnet.public_subnet_1.id
}

resource "aws_route" "nat_route_1" {
  route_table_id = aws_route_table.nat_route_table_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
}

resource "aws_route_table" "nat_route_table_1" {
  tags = {
    Name = "surf_site_nat_route_table_1",
    Network = "Public"
  }
  vpc_id = aws_vpc.surf_private_network.id
}

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.surf_internet_gateway.id
}

resource "aws_route_table" "public_route_table" {
  tags = {
    Name = "surf_site_public_route_table",
    Network = "Public"
  }

  vpc_id = aws_vpc.surf_private_network.id
}

resource "aws_route_table_association" "public_route_table_association_0" {
  subnet_id = aws_subnet.public_subnet_0.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "public_subnet_0" {
  availability_zone = "us-west-2a"
  cidr_block = "10.0.200.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "surf_site_public_subnet_0"
    SubnetType = "Public"
  }

  vpc_id = aws_vpc.surf_private_network.id
}

resource "aws_subnet" "public_subnet_1" {
  availability_zone = "us-west-2b"
  cidr_block = "10.0.201.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "surf_site_public_subnet_1"
    SubnetType = "Public"
  }

  vpc_id = aws_vpc.surf_private_network.id
}

resource "aws_vpc" "surf_private_network" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_flow_log" "surf_flow_log" {
  iam_role_arn    = aws_iam_role.surf_flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.surf_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.surf_private_network.id
}

resource "aws_iam_role" "surf_flow_log_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "root"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  path = "/"
}

resource "aws_cloudwatch_log_group" "surf_log_group" {}
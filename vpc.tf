## VPC Creation (roboshop-dev-vpc(Name of the VPC)), 
resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default" # defines the tenancy (placement) of EC2 instances that will run inside that VPC.
  enable_dns_hostnames = "true"

  tags = merge(
        var.vpc_tags,
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-vpc"
        }
    )
  
}

##  IGW Creation (roboshop-dev-igw (Name of the Internet Gateway))

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # ID of the VPC to which the Internet Gateway will be attached.

  tags = merge(
        var.igw_tags,
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-igw"
        }
    )
  
}

## Creating Public Subnet (roboshop-dev-public-us-east-1a)
resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id 
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az-names[count.index]
  # availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = "true"
  tags =merge(
        var.Public_subnet_tags,
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-public-${local.az-names[count.index]}"
        }
    )
    
  }

##roboshop-dev-private-east1a
  resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az-names[count.index]
  # availability_zone = data.aws_availability_zones.available.names[count.index] 
  tags =merge(
        var.private_subnet_tags,
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-private-${local.az-names[count.index]}"
        }
    )
    
  }

##roboshop-dev-database-east1
  resource "aws_subnet" "database" {
    count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az-names[count.index]
  # availability_zone = data.aws_availability_zones.available.names[count.index]

  tags =merge(
        var.database_subnet_tags,
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-database-${local.az-names[count.index]}"
        }
    )
    
  }

# EIP Creation for NAT Gateway
  resource "aws_eip" "eip" {
   domain           = "vpc" # (Optional) Indicates if this EIP is for use in VPC (vpc).
   tags = merge(
        var.eip_gateway_tags,
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-eip"
        }
    )

}

#NAT Gateway Creation

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.eip.id # Allocation ID of the Elastic IP address.
  subnet_id     = aws_subnet.public[0].id # Subnet ID of the public subnet where the NAT Gateway will be deployed.

  tags = merge(
        var.eip_gateway_tags,
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-nat"
        }
    )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main] # This ensures that the NAT Gateway is created after the Internet Gateway is available.
}


# Route Tables Creation 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

    tags = merge(
        var.Public_route_table,
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-public"
        }
    )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

    tags = merge(
        var.private_route_table,
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-private"
        }
    )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

    tags = merge(
        var.database_route_table,
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-database"
        }
    )
}

# Routes Creation for Internet Gateway and NAT Gateway 

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}


resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

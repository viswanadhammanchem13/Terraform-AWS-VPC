resource "aws_vpc_peering_connection" "default" {
    count = var.is_peering_required ? 1 : 0
    peer_vpc_id   = data.aws_vpc.default.id # Accepter VPC ID
    vpc_id        = aws_vpc.main.id # Requester VPC ID

    accepter {
        allow_remote_vpc_dns_resolution = true
    }

    requester {
         allow_remote_vpc_dns_resolution = true
    }

    auto_accept = true
    tags = merge(
        var.vpc_peering_tags,
            local.common_tags,
            {
                Name = "${var.project}-${var.environment}-peering"
            }
        )
}

resource "aws_route" "public_peering" {
    count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[0].id
}

resource "aws_route" "private_peering" {
    count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[0].id
}

resource "aws_route" "database_peering" {
    count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[0].id
}

## We should add peering connection in default main route table as well to allow communication from default VPC to our new VPC

resource "aws_route" "default_peering" {
    count = var.is_peering_required ? 1 : 0
  route_table_id            = data.aws_route_table.main.id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[0].id
}
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = merge(var.common_tags, {
    Name = "${var.project}-vpc"
  })
}

resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 10 + count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = merge(var.common_tags, {
    Name = "${var.project}-public-${count.index}"
  })
}

resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 40 + count.index)
  availability_zone = var.availability_zones[count.index]
  tags = merge(var.common_tags, {
    Name = "${var.project}-private-${count.index}"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.common_tags, {
    Name = "${var.project}-igw"
  })
}

resource "aws_eip" "nat" {

}

resource "aws_nat_gateway" "this" {
  count         = var.deploy_nat ? 1 : 0
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.common_tags, {
    Name = "${var.project}-ngw"
  })
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.common_tags, {
    Name = "${var.project}-public-rt"
  })

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.common_tags, {
    Name = "${var.project}-private-rt"
  })
}

resource "aws_route" "private-nat-route" {
  count                  = length(aws_nat_gateway.this)
  route_table_id         = aws_route_table.rt_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "public_route_link" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "private_route_link" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.rt_private.id
}
data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_subnet" "public" {
  count                   = 3
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, 3 + count.index)
  availability_zone       = data.aws_availability_zones.this.names[count.index]
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count             = 3
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.this.names[count.index]
  vpc_id            = aws_vpc.this.id
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-ecs-demo"
  }
}
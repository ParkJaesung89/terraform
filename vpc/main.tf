######################################
## vpc

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = format("%s-vpc", var.name)
    },
    var.tags
  )
}


######################################
## Subnet

# public subnet
resource "aws_subnet" "public" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["zone"]
  # AUTO-ASIGN PUBLIC IP
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = format(
        "%s-pub-sub-%s",
        var.name,
        element(split("_", each.key), 2)
      )
    },
    var.tags,
  )
}

## private subnet
#resource "aws_subnet" "private" {
#  for_each          = var.private_subnets
#  vpc_id            = aws_vpc.vpc.id
#  cidr_block        = each.value["cidr"]
#  availability_zone = each.value["zone"]
#
#  tags = merge(
#    {
#      Name = format(
#        "%s-pri-sub-%s",
#        var.name,
#        element(split("_", each.key), 2)
#      )
#    },
#    var.tags,
#  )
#}

# lb subnet
resource "aws_subnet" "web_lb" {
  #for_each          = var.lb_subnets_web
  for_each = { for idx, subnet in var.lb_subnets_web : idx => subnet }      # var.lb_subnets_web의 리스트를 for_each에 사용하도록 맵 형식으로 변환

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["zone"]
  # AUTO-ASIGN LB IP
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name = format(
        "%s-web-lb-sub-%s",
        var.name,
        element(split("_", each.key), 2)
      )
    },
    var.tags,
  )
}


resource "aws_subnet" "was_lb" {
  #for_each          = var.lb_subnets_was
  for_each = { for idx, subnet in var.lb_subnets_was : idx => subnet }      # var.lb_subnets_was의 리스트를 for_each에 사용하도록 맵 형식으로 변환

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["zone"]
  # AUTO-ASIGN LB IP
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name = format(
        "%s-was-lb-sub-%s",
        var.name,
        element(split("_", each.key), 2)
      )
    },
    var.tags,
  )
}
######################################
## Public route table and association

# public route table
resource "aws_route_table" "public" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_internet_gateway.this]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    {
      Name = format(
        "%s-pub-rt",
        var.name,
      )
    },
    var.tags,
  )
}

# public route association
resource "aws_route_table_association" "public" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}


######################################
## Private route table and association

## private route table
#resource "aws_route_table" "private" {
#  vpc_id     = aws_vpc.vpc.id
#  depends_on = [aws_nat_gateway.nat_gw]
#
#  route {
#    cidr_block     = "0.0.0.0/0"
#    nat_gateway_id = aws_nat_gateway.nat_gw.id
#  }
#
#  tags = merge(
#    {
#      Name = format(
#        "%s-pri-rt",
#        var.name,
#      )
#    },
#    var.tags,
#  )
#}
#
## private route association
#resource "aws_route_table_association" "private" {
#  for_each       = var.private_subnets
#  subnet_id      = aws_subnet.private[each.key].id
#  route_table_id = aws_route_table.private.id
#}

#####################################
# lb route table and association

# lb route table
resource "aws_route_table" "web_lb_rt" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_internet_gateway.this]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    {
      Name = format(
        "%s-web-lb-rt",
        var.name,
      )
    },
    var.tags,
  )
}

resource "aws_route_table" "was_lb_rt" {
  vpc_id     = aws_vpc.vpc.id
  
  tags = merge(
    {
      Name = format(
        "%s-was-lb-rt",
        var.name,
      )
    },
    var.tags,
  )
}

#lb route association
resource "aws_route_table_association" "web_lb_rt_association" {
  #for_each       = var.lb_subnets_web
  for_each = { for idx, subnet in var.lb_subnets_web : idx => subnet }

  subnet_id      = aws_subnet.web_lb[each.key].id
  route_table_id = aws_route_table.web_lb_rt.id
}

resource "aws_route_table_association" "was_lb_rt_association" {
  #for_each       = var.lb_subnets_web
  for_each = { for idx, subnet in var.lb_subnets_web : idx => subnet }

  subnet_id      = aws_subnet.was_lb[each.key].id
  route_table_id = aws_route_table.was_lb_rt.id
}

resource "aws_route" "was_route" {
  route_table_id  = aws_route_table.was_lb_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}


######################################
## Internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = format("%s-%s-igw", var.name, terraform.workspace)
    },
    var.tags
  )
}


######################################
## Nat gateway

# nat eip
resource "aws_eip" "nat" {
  #vpc = true
  domain = "vpc"

  tags = merge(
    {
      Name = format(
        "%s-nat-eip-%s",
        var.name,
        element(split("-", var.az_names[0]), 2)
      )
    },
    var.tags
  )
}

# nat gateway
# aws_iam_user.example1["user2"].name
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["pub_sub_2a"].id

  tags = merge(
    {
      Name = format(
        "%s-nat-%s",
        var.name,
        element(split("-", var.az_names[0]), 2)
      )
    },
    var.tags
  )
}
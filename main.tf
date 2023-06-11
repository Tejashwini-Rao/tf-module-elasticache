resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.env}-rediscluster"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.redis.
  engine_version       = "3.2.10"
  port                 = 6379
  subnets_ids        =  aws_elasticache_subnet_group.redis.subnet_ids

}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.env}redis-subnet"
  subnet_ids =  module.vpc.subnets["db"].subnet_ids
}

resource "aws_elasticache_parameter_group" "redis" {
  name   = "cache-params"
  family = "redis2.8"

}

resource "aws_security_group" "redis" {
name        = "allow_tls"
description = "Allow TLS inbound traffic"
vpc_id      = aws_vpc.main.id

ingress {
description      = "TLS from VPC"
from_port        = 6379
to_port          = 6379
protocol         = "tcp"
cidr_blocks      = [aws_vpc.main.cidr_block]
ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
}

egress {
from_port        = 0
to_port          = 0
protocol         = "-1"
cidr_blocks      = ["0.0.0.0/0"]
ipv6_cidr_blocks = ["::/0"]
}

tags = {
Name = "allow_tls"
}
}
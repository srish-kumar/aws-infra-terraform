output "vpc-id" {
  value = aws_vpc.terravpc.id
}

output "subnet1-id" {
  value = aws_subnet.terra-subnet-1.id
}

output "subnet2-id" {
  value = aws_subnet.terra-subnet-2.id
}

output "loadbalance-dns" {
  value = aws_lb.alb.dns_name
}
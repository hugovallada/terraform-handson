output "vpc-id" {
  value = aws_vpc.vpc-chat.id
}

output "vpc-arn" {
  value = aws_vpc.vpc-chat.arn
}

output "subnet-0-name" {
  value = aws_subnet.vpc-chat-public-subnet[0].tags.Name
}

output "subnet-1-name" {
  value = aws_subnet.vpc-chat-public-subnet[1].tags.Name
}

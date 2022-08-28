output "app_subnet_0" {
    value = aws_subnet.app_subnet_0.id
}

output "app_subnet_1" {
    value = aws_subnet.app_subnet_1.id
}

output "public_subnet_0" {
    value = aws_subnet.public_subnet_0.id
}

output "public_subnet_1" {
    value = aws_subnet.public_subnet_1.id
}

output "data_subnet_0" {
    value = aws_subnet.data_subnet_0.id
}

output "data_subnet_1" {
    value = aws_subnet.data_subnet_1.id
}

output "vpc" {
    value = aws_vpc.surf_private_network.id
}

output "vpc_cidr" {
    value = aws_vpc.surf_private_network.cidr_block
}
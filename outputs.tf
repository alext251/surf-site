# network module output

output "app_subnet_0" {
    value = module.network.app_subnet_0
}

output "app_subnet_1" {
    value = module.network.app_subnet_1
}

output "public_subnet_0" {
    value = module.network.public_subnet_0
}

output "public_subnet_1" {
    value = module.network.public_subnet_1
}

output "data_subnet_0" {
    value = module.network.data_subnet_0
}

output "data_subnet_1" {
    value = module.network.data_subnet_1
}

output "vpc_id" {
    value = module.network.vpc
}

output "vpc_cidr_block" {
    value = module.network.vpc_cidr
}
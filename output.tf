#To output particular attributes
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet_id" {
    value = aws_subnet.public_subnet[*].id 
}

#IF WE WANT TO OUTPUT THE PUBLIC IP OF AN EC2 INSTANCE WE DO THE FOLLOWING:
# output "name" {
#   value = aws_instance.webserver.public_ip
# }


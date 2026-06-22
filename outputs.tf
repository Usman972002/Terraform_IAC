#output "ec2_public_ip" {
# value = aws_instance.my_ec2_instance.public_ip
#}

#output "ec2_public_dns" {
#  value = aws_instance.my_ec2_instance.public_dns
#}

#output "ec2_private_ip" {
#  value = aws_instance.my_ec2_instance.private_ip
#}

# This output works only when a meta argument COUNT is used under ec2 instance
#output "ec2_public_ip" {
# value = aws_instance.my_ec2_instance[*].public_ip
#}

#output "ec2_public_dns" {
#  value = aws_instance.my_ec2_instance[*].public_dns
#}

#output "ec2_private_ip" {
#  value = aws_instance.my_ec2_instance[*].private_ip
#}

# This output works only for for_each meta argument used under ec2 instance
output "ec2_public_ip" {
value = [
    for key in aws_instance.my_ec2_instance : key.public_ip
  ]
}

output "ec2_public_dns" {
value = [
  for key in aws_instance.my_ec2_instance : key.public_dns
]
}

output "ec2_private_ip" {
value =  [
  for key in aws_instance.my_ec2_instance : key.private_ip
	]
}



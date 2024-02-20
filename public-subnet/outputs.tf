output "PublicSubnet1" {
  value       = aws_subnet.PublicSubnet1.id
  description = "This is the 1st public subnet id"
}

output "PublicSubnet2" {
  value       = aws_subnet.PublicSubnet2.id
  description = "This is second public subnet id"
}

output "PublicRouteTable" {
  value       = aws_route_table.PublicRouteTable.id
  description = "Custom public route table id"
}
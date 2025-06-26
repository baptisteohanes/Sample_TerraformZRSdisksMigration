# Outputs for the Azure VM deployment

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "virtual_machine_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "public_ip_address" {
  description = "Public IP address of the virtual machine"
  value       = azurerm_public_ip.main.ip_address
}

output "private_ip_address" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.main.private_ip_address
}

output "ssh_connection_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.main.ip_address}"
}

output "os_disk_storage_type" {
  description = "Storage account type of the OS disk (confirming it's NOT ZRS)"
  value       = azurerm_linux_virtual_machine.main.os_disk[0].storage_account_type
}

output "os_disk_size" {
  description = "Size of the OS disk in GB"
  value       = azurerm_linux_virtual_machine.main.os_disk[0].disk_size_gb
}

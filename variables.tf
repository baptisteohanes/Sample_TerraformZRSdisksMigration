# Variables for the Azure VM deployment

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-vm-demo"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm-demo"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "Administrator password for the VM"
  type        = string
  sensitive   = true
}

variable "os_disk_size" {
  description = "Size of the OS disk in GB"
  type        = number
  default     = 30
}

variable "storage_account_type" {
  description = "Storage account type for OS disk (NOT ZRS enabled)"
  type        = string
  default     = "Standard_LRS"
  validation {
    condition = contains([
      "Standard_LRS",
      "Premium_LRS",
      "StandardSSD_LRS",
      "UltraSSD_LRS"
    ], var.storage_account_type)
    error_message = "Storage account type must be one of: Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS (ZRS types are excluded)."
  }
}

# Azure VM with Non-ZRS OS Disk - Terraform

This Terraform configuration creates a simple Azure Linux VM with an OS disk that is **NOT** ZRS (Zone Redundant Storage) enabled. The VM uses Standard LRS (Locally Redundant Storage) by default, which stores data within a single availability zone.

## Resources Created

- **Resource Group**: Container for all resources
- **Virtual Network**: Network infrastructure with a subnet
- **Public IP**: Static public IP address for external access
- **Network Security Group**: Firewall rules allowing SSH (22) and RDP (3389)
- **Network Interface**: Connects the VM to the virtual network
- **Linux Virtual Machine**: Ubuntu 20.04 LTS with **non-ZRS OS disk**

## Key Features

- **OS Disk Storage**: Uses `Standard_LRS` (NOT ZRS enabled)
- **Authentication**: Password-based authentication (SSH keys disabled)
- **Security**: Network Security Group with basic inbound rules
- **Networking**: Public and private IP addresses
- **OS**: Ubuntu 20.04 LTS

## Prerequisites

1. **Terraform installed**: If not installed, use winget:
   ```powershell
   winget install Hashicorp.Terraform
   ```

2. **Azure CLI**: Installed and authenticated
   ```powershell
   az login
   ```

## Deployment Instructions

### 1. Initialize Terraform
```powershell
terraform init
```

### 2. Validate Configuration
```powershell
terraform validate
```

### 3. Plan Deployment
```powershell
terraform plan
```

### 4. Apply Configuration
```powershell
terraform apply -auto-approve
```

## Customization

Copy `terraform.tfvars.example` to `terraform.tfvars` and modify the values:

```hcl
resource_group_name = "rg-my-vm"
location           = "West US 2"
vm_name           = "my-vm"
vm_size           = "Standard_B2ms"
admin_username    = "myuser"
admin_password    = "YourSecurePassword123!"  # Must meet Azure password complexity requirements
os_disk_size      = 50
storage_account_type = "Premium_LRS"  # Options: Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS
```

## Storage Account Types (Non-ZRS)

The configuration specifically uses non-ZRS storage types:

- **Standard_LRS**: Standard locally redundant storage (default)
- **Premium_LRS**: Premium locally redundant storage
- **StandardSSD_LRS**: Standard SSD locally redundant storage
- **UltraSSD_LRS**: Ultra SSD locally redundant storage

**Note**: ZRS (Zone Redundant Storage) types are intentionally excluded from this configuration.

## Connecting to the VM

After deployment, you can connect to the VM using:

### Option 1: SSH (if you have an SSH client)
```powershell
ssh adminuser@<public_ip_address>
```

### Option 2: Azure Portal
1. Go to the Azure Portal
2. Navigate to your VM
3. Click "Connect" and choose your preferred method

### Option 3: RDP (if you install a desktop environment)
```powershell
mstsc /v:<public_ip_address>
```

The public IP address will be displayed in the Terraform outputs.

## Outputs

The configuration provides these outputs:

- `public_ip_address`: Public IP of the VM
- `private_ip_address`: Private IP of the VM
- `ssh_connection_command`: Ready-to-use SSH command (if SSH is available)
- `os_disk_storage_type`: Confirms the storage type (non-ZRS)
- `os_disk_size`: Size of the OS disk

## Password Requirements

When setting the `admin_password` variable, ensure it meets Azure's complexity requirements:

- **Length**: At least 12 characters
- **Complexity**: Must contain 3 of the following 4 character types:
  - Lowercase letters (a-z)
  - Uppercase letters (A-Z)
  - Numbers (0-9)
  - Special characters (!@#$%^&*()_+-=[]{}|;:,.<>?)
- **Restrictions**: Cannot contain the username or common passwords

## Cleanup

To destroy all resources:

```powershell
terraform destroy -auto-approve
```

## Files Structure

- `main.tf`: Main Terraform configuration
- `variables.tf`: Variable definitions
- `outputs.tf`: Output definitions
- `terraform.tfvars.example`: Example variables file
- `README.md`: This documentation

## Security Considerations

- The VM is accessible from the internet (0.0.0.0/0)
- Consider restricting source IP addresses in the NSG rules
- Password authentication is enabled - ensure you use a strong password
- Update the VM regularly after deployment
# Azure VM with Configurable OS Disk - Terraform

This Terraform configuration creates a simple Azure Linux VM with configurable OS disk options. You can either:

1. **Create a new OS disk** with Standard LRS (Locally Redundant Storage) - NOT ZRS enabled
2. **Use an existing managed disk** as the OS disk

## Resources Created

- **Resource Group**: Container for all resources
- **Virtual Network**: Network infrastructure with a subnet
- **Public IP**: Static public IP address for external access
- **Network Security Group**: Firewall rules allowing SSH (22) and RDP (3389)
- **Network Interface**: Connects the VM to the virtual network
- **Linux Virtual Machine**: Ubuntu 20.04 LTS with configurable OS disk

## Key Features

- **Configurable OS Disk**: Option to use existing disk or create new one
- **OS Disk Storage**: Uses `Standard_LRS` by default (NOT ZRS enabled) when creating new disk
- **Existing Disk Support**: Can attach to an already existing managed disk
- **Authentication**: Password-based authentication (SSH keys disabled)
- **Security**: Network Security Group with basic inbound rules
- **Networking**: Public and private IP addresses
- **OS**: Ubuntu 20.04 LTS

## Configuration Options

### Using Existing Disk

To use an existing managed disk as the OS disk:

1. Set `use_existing_disk = true`
2. Provide the full resource ID of the existing disk in `existing_disk_id`

Example:
```hcl
use_existing_disk = true
existing_disk_id  = "/subscriptions/your-subscription-id/resourceGroups/your-rg/providers/Microsoft.Compute/disks/your-existing-disk-name"
```

### Creating New Disk (Default)

To create a new OS disk:

1. Set `use_existing_disk = false` (or omit it, as false is default)
2. Configure `os_disk_size` and `storage_account_type` as needed

Example:
```hcl
use_existing_disk    = false
os_disk_size         = 30
storage_account_type = "Standard_LRS"
```

## Prerequisites

1. **Terraform installed**: If not installed, use winget:
   ```powershell
   winget install Hashicorp.Terraform
   ```

2. **Azure CLI**: Installed and authenticated
   ```powershell
   az login
   ```

3. **Existing Disk** (if using existing disk option): The managed disk must already exist in Azure

## Deployment Instructions

### 1. Configure Variables

Copy the example file and modify it:
```powershell
# For existing disk usage:
Copy-Item terraform.tfvars.existing-disk.example terraform.tfvars

# For new disk creation:
Copy-Item terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your specific values.

### 2. Initialize Terraform
```powershell
terraform init
```

### 3. Validate Configuration
```powershell
terraform validate
```

### 4. Plan Deployment
```powershell
terraform plan
```

### 5. Apply Configuration
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
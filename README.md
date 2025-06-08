# Terraform AWS Infrastructure

This Terraform configuration creates a complete AWS infrastructure with:
- VPC with public subnets
- Internet Gateway
- Route Tables
- Security Groups
- Load Balancer
- Auto Scaling Group with Launch Template

## Project Structure

```
.
├── main.tf                 # Root module configuration
├── modules/
│   ├── vpc/               # VPC module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── elb/               # Load Balancer module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── asg/               # Auto Scaling Group module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md
```

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version >= 1.0.0)

## Usage

1. Initialize Terraform:
```bash
terraform init
```

2. Review the planned changes:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply
```

4. To destroy the infrastructure:
```bash
terraform destroy
```

## Module Details

### VPC Module
- Creates a VPC with two public subnets
- Sets up Internet Gateway and Route Tables
- Configures DNS support

### ELB Module
- Creates a security group for web traffic
- Sets up a load balancer with HTTP listener
- Configures health checks

### ASG Module
- Creates a launch template with user data
- Sets up an Auto Scaling Group
- Configures instance refresh and health checks

## Variables

Key variables can be modified in the root `main.tf` file:
- VPC CIDR block
- Subnet CIDR blocks
- Instance type
- Auto Scaling Group capacity settings
- Environment name

## Outputs

The configuration outputs:
- VPC ID
- Subnet IDs
- Load Balancer DNS name
- Auto Scaling Group name 
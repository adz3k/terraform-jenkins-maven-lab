# Terraform Jenkins Maven Lab

## Overview
This project provisions AWS infrastructure with Terraform and automates Jenkins installation on an EC2 instance using user data scripts.

## Architecture
- Jenkins EC2 instance
- Production EC2 instance
- VPC networking
- Public subnet
- Security groups
- Key pair authentication
- User data scripts for automated setup

## Features
- Infrastructure as Code with Terraform
- Automated Jenkins installation
- Automated Java, Git, and Maven installation
- Reusable variable-based configuration
- Example tfvars file included

## Tech Stack
- Terraform
- AWS EC2
- AWS VPC
- Bash
- Jenkins

## Project Files
- `main.tf` - core infrastructure resources
- `provider.tf` - AWS provider configuration
- `variables.tf` - input variables
- `output.tf` - Terraform outputs
- `userdata1.sh` - Jenkins setup script
- `userdata2.sh` - secondary instance setup script
- `terraform.tfvars.example` - sample variable file
- `.gitignore` - excludes secrets and local state

## Prerequisites
- Terraform installed
- AWS account
- AWS credentials configured locally
- Existing key pair or Terraform-managed key setup

## Setup
1. Clone the repository
2. Copy `terraform.tfvars.example` to `terraform.tfvars`
3. Fill in your own values
4. Run `terraform init`
5. Run `terraform plan`
6. Run `terraform apply`

## Notes
Sensitive files such as Terraform state files, tfvars, and private keys are excluded from version control.

## Future Improvements
- Add remote Terraform state
- Add outputs for public IPs and Jenkins URL
- Add screenshots of deployed infrastructure
- Add modules for cleaner structure

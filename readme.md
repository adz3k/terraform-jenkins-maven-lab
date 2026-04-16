# Terraform Jenkins Maven Lab

## Overview
This project provisions AWS infrastructure using Terraform and uses shell scripts to configure instances.

## Files
- main.tf
- provider.tf
- variables.tf
- output.tf
- userdata1.sh
- userdata2.sh

## What it does
- Provisions AWS EC2 instances using Terraform
- Sets up a Jenkins server automatically using user data scripts
- Configures dependencies (Java, Git, Maven, Jenkins)

## Tech Stack
- Terraform
- AWS (EC2, VPC, Security Groups)
- Bash (user data scripts)
- Jenkins

## Notes
Sensitive files such as terraform state, tfvars, and private keys are excluded from version control.
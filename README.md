# azure-vm-ssh-automation

# Azure VM SSH Automation Script

This project automates the process of connecting to an Azure Virtual Machine using Azure CLI, removing the need for manual steps via the Azure Portal.

## Problem Statement
Connecting to an Azure VM typically requires:
- Logging into Azure Portal
- Locating the VM
- Checking its power state
- Starting the VM (if stopped)
- Finding the public IP
- Running SSH manually
- Stop if not using

This script automates the entire workflow using CLI-based automation.

## Workflow
1. User logs in using `az login`
2. Script lists available VMs with their resource groups
3. User selects the VM name and resource group
4. VM is started automatically if stopped
5. Script waits for the VM to be running
6. Public IP address is retrieved
7. User provides SSH key path
8. SSH connection is established automatically
9. if ssh session ends, askes to stop VM

## Supported Platforms
- Windows PowerShell
- Bash (Linux / macOS / WSL)

## Tools & Technologies
- Azure CLI
- PowerShell
- Bash
- Azure Virtual Machines
- SSH


#!/bin/bash
# Azure VM Connect Script

echo "=== Azure VM Interactive Connection Script ==="
echo "1. Logging into Azure..."
az login

echo -e "\n2. Listing all VMs and Resource Groups..."
az vm list --query "[].{Name:name, RG:resourceGroup, Location:location, PowerState:powerState}" --output table

echo -e "\n3. Enter VM Name to start:"
read -p "VM Name: " VM_NAME

echo -e "\n4. Enter Resource Group:"
read -p "Resource Group: " RG_NAME

echo -e "\n5. Starting VM: $VM_NAME in $RG_NAME..."
az vm start -g "$RG_NAME" -n "$VM_NAME"

echo "Waiting for VM to start (30 seconds)..."
sleep 30

echo -e "\n6. Getting public IP address..."
IP=$(az vm show -d -g "$RG_NAME" -n "$VM_NAME" --query publicIps[0] -o tsv)

if [ -z "$IP" ] || [ "$IP" == "null" ]; then
    echo "No public IP found for $VM_NAME"
    echo "Private IP: $(az vm show -g "$RG_NAME" -n "$VM_NAME" --query privateIps[0] -o tsv)"
    exit 1
fi

echo "Public IP: $IP"

echo -e "\n7. Enter SSH Key Path (e.g., C:/Users/Murali/Downloads/key.pem):"
read -p "SSH Key Path: " SSH_KEY

echo -e "\n Connecting to $VM_NAME via SSH..."
echo "ssh -i \"$SSH_KEY\" azureuser@$IP"
ssh -i "$SSH_KEY" azureuser@$IP

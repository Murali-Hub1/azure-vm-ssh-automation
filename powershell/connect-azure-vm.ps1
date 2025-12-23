# Azure VM Connect Script

Write-Host "=== Azure VM Interactive Connection Script ===" -ForegroundColor Green
Write-Host "1. Logging into Azure..." -ForegroundColor Yellow
az login

Write-Host "2. Listing all VMs and Resource Groups..." -ForegroundColor Yellow
az vm list --query "[].{Name:name, RG:resourceGroup, Location:location, PowerState:powerState}" --output table

$VM_NAME = Read-Host "3. Enter VM Name:"
$RG_NAME = Read-Host "4. Enter Resource Group:"

Write-Host "5. Starting VM: $VM_NAME in $RG_NAME..." -ForegroundColor Yellow
az vm start -g $RG_NAME -n $VM_NAME

Write-Host "Waiting for VM to start (10 seconds)..."
Start-Sleep -Seconds 10

$PublicIP  = az vm show -d -g $RG_NAME -n $VM_NAME --query "publicIps"  -o tsv
$PrivateIP = az vm show -d -g $RG_NAME -n $VM_NAME --query "privateIps" -o tsv

if ([string]::IsNullOrEmpty($PublicIP) -or $PublicIP -eq "null") {
    Write-Host "No public IP found. Using private IP: $PrivateIP" -ForegroundColor Yellow
    $ConnectIP = $PrivateIP
} else {
    Write-Host "Public IP: $PublicIP" -ForegroundColor Green
    $ConnectIP = $PublicIP
}

$SSH_KEY = Read-Host "7. Enter SSH Key Path"
Write-Host "Connecting to $VM_NAME at $ConnectIP via SSH..."
& ssh -i $SSH_KEY azureuser@$ConnectIP

$STOP_CHOICE = Read-Host "Do you want to STOP the VM now to save cost? (y/n)"

if ($STOP_CHOICE -eq "y" -or $STOP_CHOICE -eq "Y") {
    Write-Host "Stopping VM $VM_NAME in $RG_NAME..." -ForegroundColor Yellow
    az vm deallocate -g $RG_NAME -n $VM_NAME
    Write-Host "VM stopped (deallocated)." -ForegroundColor Green
} else {
    Write-Host "VM left running." -ForegroundColor Yellow
}

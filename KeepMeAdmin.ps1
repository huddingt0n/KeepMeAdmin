# Run Command as Admin in Powershell: 
# 1. Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# 2. .\KeepMeAdmin.ps1

$regPath = "HKLM:\SOFTWARE\Policies\Sinclair Community College\Make Me Admin"

# Get current user info
$username = $env:USERNAME
$sid = (New-Object System.Security.Principal.NTAccount($username)).Translate([System.Security.Principal.SecurityIdentifier]).Value

Write-Host "[~] User: $username"
Write-Host "[~] SID:  $sid"

# Create registry key if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Host "[+] Registry key created"
}

 Write-Host "[~] Reg Path: \HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Sinclair Community College\Make Me Admin"

# Create Automatic Add Allowed value first, then populate with SID
New-ItemProperty -Path $regPath -Name "Automatic Add Allowed" -PropertyType MultiString -Value "" -Force | Out-Null
Write-Host "[+] Automatic Add Allowed value created"

Set-ItemProperty -Path $regPath -Name "Automatic Add Allowed" -Value @($sid)
Write-Host "[+] SID populated into Automatic Add Allowed"

# Set Remove Admin Rights On Logout to 0
Set-ItemProperty -Path $regPath -Name "Remove Admin Rights On Logout" -Value 0 -Type DWord -Force
Write-Host "[+] Remove Admin Rights On Logout set to 0"

# Countdown and restart
Write-Host ""
Write-Host "[*] Restarting in 10 seconds..."
Start-Sleep -Seconds 10
Restart-Computer -Force
# Powershell Script to install and configure Active Directory, DHCP, DNS, and NTP

# Written by Logan Flecke

# Set variable values
$interface_name = "Ethernet"
$ip_address = "192.168.1.10"
$default_gateway = "192.168.1.1"
$domain_name = "logan.local"
$timezone = "Eastern Standard Time"
$dsrm_password = Read-Host "Enter Directory Services Restore Password" -AsSecureString

$logfile = "C:\Users\Administrator\AD-Setup-log.txt"

# Setup logging
if (Test-Path $logfile){
    Write-Host "Log File exists at $logfile"
} else {
    New-Item -Path $logfile -ItemType File
    Write-Host "Created Log FIle at $logfile"
}

$firstcheck = Select-String -Path $logfile -Pattern "#### Networking, Active Directory, and DNS Install Complete ####"
if(!$firstcheck) {
    Add-Content $logfile "Starting setup of Networking, Active Directory, and DNS"
    # Configure IP Addressing
    Add-Content $logfile "Setting static IP to $ip_address on interface $interface_name"

    $interface = Get-NetIPConfiguration -InterfaceAlias $interface_name
    $interface | Set-NetIPInterface -Dhcp Disabled
    $interface | New-NetIPAddress -IPAddress $ip_address -PrefixLength 24 -DefaultGateway $default_gateway
    Set-DnsClientServerAddress -InterfaceAlias $interface_name -ServerAddresses ("127.0.0.1", "8.8.8.8")

    Write-Host "Networking Configured"
    $ip_info = ipconfig /all
    Add-Content $logfile $ip_info 
    Add-Content $logfile "### Networking Configured ###"

    # Enable RDP
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
    Write-Host "RDP Enabled"
    Add-Content $logfile "RDP Enabled"

    # Install and Configure Active Directory
    Add-Content $logfile "Creating AD Domain $domain_name."
    Write-Host "Installing Active Directory and DNS on $domain_name."

    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
    Install-ADDSForest -DomainName $domain_name -InstallDNS -ErrorAction Stop -NoRebootOnCompletion -SafeModeAdministratorPassword $dsrm_password -Confirm:$false
    Add-Content $logfile "#### Networking, Active Directory, and DNS Install Complete ####"
    Restart-Computer -ComputerName $env:computername -ErrorAction Stop
}


# Install and Configure DHCP
Write-Host "Starting DHCP Setup"
Add-Content "Starting DHCP Setup"
Install-WindowsFeature -Name DHCP -IncludeManagementTools
$server_dns_name = Get-DnsServerSetting
$server_dns_name = $server_dns_name.ComputerName
Add-DhcpServerInDC -DnsName $server_dns_name -IPAddress $ip_address

Write-Host "DHCP Installed and Configured"

# Configure NTP
Write-Host "Setting NTP Server with timezone to $timezone"
Add-Content $logfile "Setting NTP Server with timezone to $timezone"
tzutil /s $timezone
w32tm /config /manualpeerlist:"time.windows.com" /syncfromflags:manual /reliable:yes /update

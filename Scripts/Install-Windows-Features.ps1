# Powershell Script to install and configure Active Directory, DHCP, DNS, and NTP

# Written by Logan Flecke

# Set variable values
$interface_name = "Ethernet"
$ip_address = "192.168.1.10"
$default_gateway = "192.168.1.1"
$domain_name = "logan.local"
$timezone = "Eastern Standard Time"
$dsrm_password = Read-Host "Enter Directory Services Restore Password" -AsSecureString

# Configure IP Addressing
$interface = Get-NetIPConfiguration -InterfaceAlias $interface_name
$interface | Set-NetIPInterface -Dhcp Disabled
$interface | New-NetIPAddress -IPAddress $ip_address -PrefixLength 24 -DefaultGateway $default_gateway
Set-DnsClientServerAddress -InterfaceAlias $interface_name -ServerAddresses ("127.0.0.1", "8.8.8.8")
Write-Host "Networking Configured"

# Install and Configure Active Directory
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName $domain_name -InstallDNS -ErrorAction Stop -NoRebootOnCompletion -SafeModeAdministratorPassword $dsrm_password -Confirm:$false
Restart-Computer -ComputerName $env:computername -ErrorAction Stop
Write-Host "Active Directory and DNS Installed and Configured"

# Install and Configure DHCP
Install-WindowsFeature -Name DHCP -IncludeManagementTools
$server_dns_name = Get-DnsServerSetting
$server_dns_name = $server_dns_name.ComputerName
Add-DhcpServerInDC -DnsName $server_dns_name -IPAddress $ip_address
Write-Host "DHCP Installed and Configured"

# Configure NTP
tzutil /s $timezone
w32tm /config /manualpeerlist:"time.windows.com" /syncfromflags:manual /reliable:yes /update

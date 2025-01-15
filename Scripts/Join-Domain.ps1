# Script to Join a computer to a Domain, used before launching an attack from the Attacker machine
# Written by Logan Flecke

$interface_name = "Ethernet"
$dns_server = "192.168.1.10"
$domain_name = "logan.local"
$server_name = "DC01"

# Enable RDP
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Write-Host "RDP Enabled"

# Configure IP Addressing
Write-Host "Setting DNS IP to $dns_server on interface $interface_name"

$interface = Get-NetIPConfiguration -InterfaceAlias $interface_name
$interface | Set-NetIPInterface -Dhcp Enabled
Set-DnsClientServerAddress -InterfaceAlias $interface_name -ServerAddresses ($dns_server, "8.8.8.8")

Write-Host "Networking Configured"

# Join to Domain
Write-Host "Joining to Domain $domain_name"
Add-Computer -DomainName "LOGAN" -Server "LOGAN\$server_name" -Restart

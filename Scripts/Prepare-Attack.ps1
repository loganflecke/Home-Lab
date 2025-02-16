# PowerShell to configure a Windows 11 to remotely invoke Atomic Red Team on a Windows machine on the same domain
# Written by Logan Flecke

# Requirements
# - C:\AtomicRedTeam\invoke-atomic-red-team path exists with Invoke-AtomicRedTeam.psm1 PowerShell Module
# - The Windows machine this is executed on must on the same domain as the target

$dc_domain_name = "DC01.domain.local"
$domain = "DOMAIN"

# Import Invoke-AtomicRedTeam
Import-Module C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psm1
Import-Module C:\AtomicRedTeam\invoke-atomicredteam\Public\Default-ExecutionLogger.psm1

# Remove unavailable PowerShell sessions
# Add "Where-Object -Property State -ne Opened" to only remove closed sessions
$closed = Get-PSSession
Remove-PSSession $closed

# Create a session to 
$sess = New-PSSession -ComputerName $dc_domain_name -Credential $domain\Administrator
$sess_id = $sess.Id

Write-Host "Use session $sess_id"
Write-Host 'Execute: "Invoke-AtomicTest T1218.010 -Session $ sess" without the space between $ and sess'

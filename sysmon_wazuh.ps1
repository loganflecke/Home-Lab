# Written by Logan Flecke

# Run as Administrator
# PowerShell to install Sysmon on a Windows Operating System and configure it to send logs to Wazuh

$sysconfig_link = 'https://wazuh.com/resources/sysconfig.xml.zip'
$sysmon_link = 'https://download.sysinternals.com/files/Sysmon.zip'

$DestinationPath = 'C:\Users\Administrator\Downloads'
$ossecConfPath = 'C:\Program Files (x86)\ossec-agent\ossec.conf'

# Define the XML block to append
$sysmonConfig = @"
<localfile>
  <location>Microsoft-Windows-Sysmon/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
"@

function Download-Expand {
    param (
        [string]$Link,
        [string]$File
    )
    Invoke-WebRequest -Uri $Link -OutFile $File
    Expand-Archive -Path $File -DestinationPath $DestinationPath -Force
}

# Download and Expand Sysmon
Download-Expand -Link $sysmon_link -File "$DestinationPath\Sysmon.zip"

# Download and Expand Sysconfig
Download-Expand -Link $sysconfig_link -File "$DestinationPath\sysconfig.xml.zip"

# Full path to Sysmon64.exe
$sysmonPath = "$DestinationPath\Sysmon\Sysmon64.exe"

# Install Sysmon with configuration
& $sysmonPath -accepteula -i "$DestinationPath\sysconfig.xml"

if (Test-Path -Path $ossecConfPath) {
    $fileContent = Get-Content -Path $ossecConfPath
    $insertIndex = $fileContent.Length - 6

    # Preserve the last 5 lines and insert the Sysmon config before them
    $fileContent = $fileContent[0..($insertIndex-1)] + $sysmonConfig + $fileContent[$insertIndex..($fileContent.Length - 1)]

    Set-Content -Path $ossecConfPath -Value $fileContent
    Write-Host "Sysmon configuration added successfully."
} else {
    Write-Host "Error: ossec.conf file not found."
}

Restart-Service -Name "WazuhSvc"
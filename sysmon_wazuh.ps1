# Written by Logan Flecke

# Run as Administrator
# PowerShell to install Sysmon on a Windows Operating System and configure it to send logs to Wazuh

$sysconfig_link = 'https://wazuh.com/resources/sysconfig.xml.zip'
$sysmon_link = 'https://download.sysinternals.com/files/Sysmon.zip'

$DestinationPath = 'C:\Users\Administrator\Downloads'
$ossecConfPath = 'C:\Program Files (x86)\ossec-agent\ossec.conf'

# Define the XML block to append, an empty line is included for readability
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

# Download and Expand Sysmon and Sysconfig
Download-Expand -Link $sysmon_link -File "$DestinationPath\Sysmon.zip"
Download-Expand -Link $sysconfig_link -File "$DestinationPath\sysconfig.xml.zip"

# Full path to Sysmon64.exe
$sysmonPath = "$DestinationPath\Sysmon\Sysmon64.exe"

# Check if ossec.conf exists and modify it
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

# Install Sysmon with configuration
if (Test-Path -Path $sysmonPath) {
    & $sysmonPath -accepteula -i "$DestinationPath\sysconfig.xml"
    Write-Host "Sysmon installed successfully."
} else {
    Write-Host "Error: Sysmon64.exe not found in expected path."
}

# Restart the Wazuh service
Restart-Service -Name "WazuhSvc"

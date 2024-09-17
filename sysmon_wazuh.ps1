# Written by Logan Flecke

# Run as Administrator
# PowerShell to install Sysmon on a Windows Operating System and configure it to send logs to Wazuh

$sysconfig_link = 'https://raw.githubusercontent.com/olafhartong/sysmon-modular/master/sysmonconfig.xml'
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

# Download and Expand Sysmon and Sysconfig
Invoke-WebRequest -Uri $sysmon_link -OutFile "$DestinationPath\Sysmon.zip"
Expand-Archive -Path "$DestinationPath\Sysmon.zip" -DestinationPath $DestinationPath -Force

Invoke-WebRequest -Uri $sysconfig_link -OutFile "$DestinationPath\sysconfig.xml"

# Full path to Sysmon64.exe
$sysmonPath = "$DestinationPath\Sysmon64.exe"

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

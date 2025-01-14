# PowerShell script to install Elastic agent, Velociraptor agent, BadBlood, and Atomic Red Team
# Network Share Lab$ is setup with the Add-To-Share function to add executables to the network share

# Written by Logan Flecke

param(
    [switch]$PowerShell, # Install PowerShell 7
    [switch]$Velociraptor # Install Velociraptor client (not supported)
)

$serverName = hostname
$shareName = "Lab$"
$Network_Share_Path = "C:\$shareName"
$sharePath = "\\$serverName\$shareName"
$fullAccessUsers = "Administrators"
$readAccessUsers = "Users"
$installPath = "C:\Program Files\Lab"

if (-not (Test-Path -Path $installPath)){
    New-Item -Path $installPath -ItemType Directory
}

# Function to create and enter into a directory for a specific tool being installed
function Make-Path {
    param(
        [string]$Name
    )
    $Directory = "$installPath\$Name"
    if (-not (Test-Path -Path $Directory)){
        New-Item -Path $Directory -ItemType Directory
        Write-Host "Created $Name at $Directory"
    }
    cd $Directory
}

# Function to add an EXE to the network share and, optionally, run it
function Add-To-Share {
    param(
        [string]$Filepath, # Path to current file location (input)
        [string]$Executable, # Name of file to execute (don't include if not executing)
        [string[]]$Arguments # Parameters passed to executable when run
    )
    if (Test-Path -Path $Filepath) {
        Copy-Item $Filepath $sharePath
        Write-Host "$Filepath Copied to $sharePath"
        }
    else  { }
    if (($Executable -eq $true) -and (Test-Path -Path "$sharePath\$Executable")){
        Start-Process -FilePath "$sharePath\$Executable" -ArgumentList $Arguments
    }
}

# Install PowerShell 7
if ($PowerShell -eq $true){
    winget install Microsoft.PowerShell --accept-package-agreements
    
    # Launch script in PowerShell 7
    & 'C:\Program Files\PowerShell\7\pwsh.exe' -File "C:\Users\Administrator\Downloads\Install-Emulation-Components.ps1"
    exit
} else {
    Write-Host "PowerShell 7 installed. Proceeding with other installations."
}

# Create Network Share
if (Test-Path $sharePath) {
    Write-Host "The SMB share '$shareName' exists."
} else {
    Write-Host "Creating SMB Share, $shareName."
    New-Item $Network_Share_Path -Type Directory
    New-SmbShare -Name $shareName -Path $Network_Share_Path -FullAccess $fullAccessUsers -ReadAccess $readAccessUsers
    Get-SmbShare
}

# Install Elastic Agent
Write-Host "Installing Elastic at $installPath\Elastic"
Make-Path -Name "Elastic"

$security_onion_username = "admin" # Username to SSH into the Security Onion console
$security_onion_ip = "172.18.1.10" # IP address of Security Onion's management interface
$elastic_directory = "$installPath\Elastic"
$agent = "so-elastic-agent_windows_amd64" # Name of the executable

scp -o StrictHostKeyChecking=no $security_onion_username@${security_onion_ip}:/opt/so/saltstack/local/salt/elasticfleet/files/so_agent-installers/$agent "$elastic_directory\$agent.exe"
Write-Host "Copied Elastic Agent from Security Onion"
Add-To-Share -FilePath "$elastic_directory\$agent.exe" # Add the agent to the network share
Start-Process -FilePath "$elastic_directory\$agent.exe" # Launch the agent
Write-Host "Elastic Agent Installed"

if ($Velociraptor -eq $true){
    # Install Velociraptor Agent
    Make-Path -Name "Velociraptor"
    $veliciraptor_directory = "C:\Users\Administrator\Downloads\Velociraptor"
    #$velociraptor_password = Read-Host "Enter Velociraptor Password" -AsSecureString
    $velociraptor_executable_url = "https://github.com/Velocidex/velociraptor/releases/download/v0.73/velociraptor-v0.73.3-windows-amd64.exe"
    $velociraptor_client_config_url = "https://172.18.1.1:8889/api/v1/DownloadVFSFile?fs_components=notebooks&fs_components=Dashboards&fs_components=Server.Monitor.Health&fs_components=uploads&fs_components=data&fs_components=client.root.config.yaml&org_id=root&vfs_path=client.root.config.yaml"
    # Download Velociraptor executable
    $velociraptor_creds = Get-Credential
    Invoke-WebRequest -Uri $velociraptor_executable_url -OutFile "$veliciraptor_directory\velociraptor-v0.73.3-windows-amd64.exe"
    Invoke-WebRequest -Uri $velociraptor_client_config_url -OutFile "$veliciraptor_directory\client.root.config.yaml" -Credential $velociraptor_creds -SkipCertificateCheck
    Invoke-WebRequest -Uri "https://172.18.1.20:8889/api/v1/DownloadVFSFile?client_id=server&fs_components=clients&fs_components=server&fs_components=collections&fs_components=F.CU2OFAHFLH394&fs_components=uploads&fs_components=scope&fs_components=Org_%3Croot%3E_velociraptor-v0.73.3-windows-amd64.msi&padding=false&zip=false&vfs_path=%2FOrg_%3Croot%3E_velociraptor-v0.73.3-windows-amd64.msi&org_id=root" -OutFile "#veliciraptor_directory\velociraptor-v0.73.3-windows-amd64.msi"  -Credential $velociraptor_creds -SkipCertificateCheck
    .\velociraptor-v0.73.3-windows-amd64.exe config repack --msi velociraptor-windows.msi client.config.yaml velociraptor-windows-repacked.msi
    .\velociraptor-windows-repacked.msi

    # Download Client Config
    scp velociraptor@172.18.1.20:/home/velociraptor/client.config.yaml C:\Users\Administrator\Downloads\Velociraptor\
    #Invoke-WebRequest -Uri $velociraptor_client_config_url -OutFile "C:\Users\Administrator\Downloads\Velociraptor\client.root.config.yaml" -SkipCertificateCheck
    .\velociraptor-v0.73.3-windows-amd64.exe config repack --msi velociraptor-windows.msi client.config.yaml velociraptor-windows-repacked.msi
    msiexec.exe velociraptor-windows-repacked.msi
}

# Install BadBlood
Write-Host "Installing BadBlood at $installPath\BadBlood"
Make-Path -Name "BadBlood"

Invoke-WebRequest "https://github.com/davidprowe/BadBlood/archive/refs/heads/master.zip" -OutFile "badblood_master.zip"
Expand-Archive badblood_master.zip
Move-Item .\badblood_master\BadBlood-master\* .
Remove-Item .\badblood_master -Recurse

$run_badblood = Read-Host "Run BadBlood Now? [Y/n]" # Prompt to run BadBlood (takes about 20-30 minutes)
if (($run_badblood -eq "Y") -or ($run_badblood -eq "y")){
    .\Invoke-BadBlood.ps1
}
Write-Host "BadBlood Installed"

# Install Atomic Red Team and exclude it in Defender
Write-Host "Installing Atomic Red Team at $installPath\AtomicRedTeam"
Make-Path -Name "AtomicRedTeam"

Add-MpPreference -ExclusionPath "$installPath\AtomicRedTeam"
Add-MpPreference -ExclusionPath "C:\AtomicRedTeam"
Write-Host "Created Exclusion in Defender for $installPath\AtomicRedTeam and C:\AtomicRedTeam"

Set-MpPreference -DisableRealtimeMonitoring $true -DisableScriptScanning $true -DisableBehaviorMonitoring $true -DisableIOAVProtection $true -DisableIntrusionPreventionSystem $true
IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing);
IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicsfolder.ps1' -UseBasicParsing);
Install-AtomicsFolder -Force
Install-AtomicRedTeam -getAtomics -Force
sleep 2
Set-MpPreference -DisableRealtimeMonitoring $false -DisableScriptScanning $false -DisableBehaviorMonitoring $false -DisableIOAVProtection $false -DisableIntrusionPreventionSystem $false
Write-Host "Atomic Red Team Installed"
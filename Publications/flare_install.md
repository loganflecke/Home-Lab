# Turning Windows 11 into a Malware Analysis Sandbox

## Installing the Flare VM for Malware Analysis
The Flare VM is used to unpack, disassemble, and debug malicious files. Mandiant has compiled "a collection of software installations scripts for Windows systems that allows you to easily set up and maintain a reverse engineering environment on a virtual machine (VM)" from their GitHub.

### Flare VM
Before diving into Flare VM, we must disable Windows Update, Firewall, and Defender. Updates can cause compatibility issues with the tools in Flare and Windows Defender and Firewall will set off alarms preventing malware from running freely. By taking these steps, you'll reveal every artifact the malware leaves behind!

### Prerequisites:
- Windows 11 VM
- Internet access
- Administrator privileges on the VM

---

## Prepare the Windows 11 VM

### First: Take a Snapshot!
To disable Defender, Update, and Firewall, their services need to be stopped and disabled. There are numerous methods to accomplish this, however some are unreliable.

#### Registry:
- Must create additional Keys that will disable certain functionality

#### Local Group Policy:
- Local Group Policy does not exist on Windows 11 Home
- Modifications to Local Group Policy may not take effect on Windows 11 Pro

#### Installing Third-Party Antivirus:
- Requires non-native software, complicating the analysis environment

For these reasons, I chose to modify their Registry values, deny access to the Registry keys, and switch the Firewall to Off. Few additional Keys are created.

---

## Disable Windows Firewall
Navigate to **Control Panel → System and Security → Windows Defender Firewall → Advanced Settings** and select **Windows Defender Firewall Properties**.

- **Windows Defender Firewall Advanced Settings**  
Switch the Firewall state to **Off**.

- **Turn off Firewall**  
Perform the same actions on **Private Profile** and **Public Profile** as **Domain Profile**.

- **Windows Defender Firewall is Off**

---

## Disable Windows Defender and Windows Update
To prevent other components of Windows from maintaining Defender after its registry value is changed, disable Tamper Protection by going to **Virus & threat protection → Manage settings**.

- **Manage Virus & threat protection settings**  
Toggle off **Tamper Protection** and, if prompted to continue, select **Yes**.

- **Disable Tamper Protection**  
Windows Services are background programs and many start automatically when Windows boots. Much of their configuration is defined in the Registry under `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services`. The **Start** key defines how they start at boot time where a value of `4` sets it to Disabled.

Below are the services that must be disabled to allow malware to run and tools to remain compatible:
- Microsoft Defender Antivirus Network Inspection Service
- Microsoft Defender Antivirus Service
- Microsoft Update Health Service
- Windows Defender Advanced Threat Protection
- Windows Update

---

## Enter into Safe Mode
Booting into Safe Mode is necessary because it limits Windows from running unnecessary services, making it easier to edit system-critical registry settings. This step ensures no active processes will interfere with our changes.

1. Enter Safe Mode by typing **Win + R**, entering **msconfig**, and selecting **OK**.
2. **Access Boot Settings**: Select **Boot**, check the **Safe boot** box, and ensure **Minimal** is selected.
3. **Reboot to Safe Mode**: Restart your computer.

---

## Modify the Registry
1. Enter the Registry Editor by typing **Win + R**, entering **regedit**, and selecting **OK**.
2. Navigate to the following registry keys under `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services`.

#### Registry keys to modify the Start value for:
- SecurityHealthService
- Sense
- WdBoot
- WdFilter
- WdNisSvc
- WinDefend
- wuauserv
- WaaSMedicSvc

3. For each key, double-click its **Start** key and change the value to `4`. Keep it as a Hexadecimal value and select **OK**. If an error occurs, proceed to "Take Ownership of a Registry Path."

---

### Take Ownership of a Registry Path
1. Right-click the registry path and select **Permissions**.
2. Select **Advanced**, then for the Owner, select **Change**. Start typing the name of the account you are using and select **Check Names**. The full username should populate. Select **OK**.
3. Proceed to modify the registry's **Start** key.

---

### Deny Access for Disabled Services Being Enabled
Ways to prevent services from starting include:
1. **Option 1**: Create Registry Keys in `HKEY_LOCAL_MACHINE\SOFTWARE\Policies`.  
   Add the following registry keys:
   - **DisableAntiSpyware**  
     `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender = 1`
   - **DisableScheduledScanning**  
     `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender = 1`
   - **DisableRealtimeMonitoring**  
     `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection = 1`

2. **Option 2**: Deny access to the SYSTEM account.  
   For Windows Update, deny SYSTEM access to the `wuauserv` registry.

---

## Exit Safe Mode
1. Exit Safe Mode by typing **Win + R**, entering **msconfig**, and selecting **OK**.
2. Reboot normally.

---

## Install Flare VM
### First: Take a Snapshot!
1. Navigate to [https://github.com/mandiant/flare-vm](https://github.com/mandiant/flare-vm) and follow the installation instructions to execute the `install.ps1` file.
2. Start a PowerShell session running as Administrator:
   ```powershell
   (New-Object net.webclient).DownloadFile('https://raw.githubusercontent.com/mandiant/flare-vm/main/install.ps1',"$([Environment]::GetFolderPath('Desktop'))\install.ps1")
   Unblock-File .\install.ps1
   Set-ExecutionPolicy Unrestricted -Force
   .\install.ps1
   ```

3. Discard tools that are not installed properly and not worth troubleshooting. For failed packages, find them in `failed_packages.txt` and execute:
   ```powershell
   choco install -y <package> <package> <package> -force
   ```

---

### Remember:
When analyzing malware, disconnect from the Internet. **Fakenet** can be used to simulate the Internet for analysis purposes.

# Home Lab

This repository contains scripts, configurations, and documentation for setting up and managing a home lab environment. The lab is designed for detection, threat hunting, and automation purposes, leveraging various tools and technologies.

## Table of Contents

- [Overview](#overview)
- [Technologies Used](#technologies-used)
- [Setup](#setup)
- [Scripts](#scripts)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Overview

This project showcases a home lab setup aimed at cybersecurity detection and automation. It provides a foundation for experimenting with various networking and security tools, including Proxmox, Open vSwitch (OVS), and other open-source security solutions like Wazuh.

The lab environment includes:
- Virtualized infrastructure using Proxmox and Open vSwitch.
- Network monitoring and security detection with Wazuh and Sysmon.
- Scripts for managing virtual machines and network configurations.

## Technologies Used

- **Proxmox**: Hypervisor for managing virtual machines.
- **Open vSwitch (OVS)**: Virtual switch for advanced network setups.
- **Wazuh**: Security Information and Event Management (SIEM) system.
- **Sysmon**: Windows event logging for security monitoring.
- **Bash**: Automation scripts for managing the lab environment.
  
## Scripts

- **`vm_power.sh`**: A script to manage the state of all Linux virtual machines (VMs) in the Proxmox datacenter. You can pass arguments like `reboot` or `shutdown` to perform the respective action on all VMs.
  
- **`proxmox-port_mirror.sh`**: A script to configure the network setup, particularly for setting up Open vSwitch (OVS) bridges and mapping them to physical interfaces such as `vmbr0`. Useful for managing virtual networks and enabling port mirroring.

- **`network_reboot.sh`**: A script that attempts to reestablish the server in the home router's DHCP leases, checks if the machine can ping `google.com`, and if it can't, it retries the commands up to a specified number of attempts (e.g., 5 iterations). This script is useful for ensuring network availability after configuration changes.

- **`sysmon_wazuh.sh`**: A PowerShell script to install Sysmon on a Windows Operating System and configure it to send logs to Wazuh

## Usage

### VM Management Script Example:
To reboot all Linux virtual machines in the Proxmox environment:
```bash
./vm_power.sh reboot
```

### Network Setup:
To configure Open vSwitch bridges and map interfaces, use the `network_setup.sh` script:
```bash
./proxmox-port_mirror.sh
```

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to enhance this repository.

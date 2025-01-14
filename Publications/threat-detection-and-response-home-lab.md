# Threat Detection and Response Home Lab

A home lab serves to apply and fill gaps in the knowledge, skills, and abilities required for any role, especially those demanding technical expertise. Designing and troubleshooting is often overlooked but this is where extensive knowledge of how systems interact is crucial.

As my first home lab, I chose to build it on-premises whereas, in the future, I'll build it in the cloud for multiple reasons (cloud engineering and investigation, high availability, etc.) The design inspiration for this lab comes from the HackTheBox Certified Defensive Security Analyst certification and a Cyber Defense class capstone project from Xavier University. All the tools used here are open source except for Windows which can still be downloaded for free.

[GitHub - loganflecke/Home-Lab: Threat Detection and Response Home Lab built with open source tools](https://github.com/loganflecke/Home-Lab)  

## Network Security

Securing the lab network is a priority to ensure controlled access and realistic segmentation of systems. Using pfSense, I've implemented a robust setup to manage traffic, enforce security policies, and enable remote access.

**pfSense** is the foundation for network security in the lab, offering advanced routing, rules, and VPN capabilities. The lab network is divided into distinct subnets, each serving a specific purpose:

- **Internal Network**: The testing grounds for attacks; Hosts Windows client machines running Active Directory.
- **DMZ**: Contains intentionally vulnerable systems.
- **DFIR**: The fun stuff; Dedicated to forensics and analysis tools, including Velociraptor, Security Onion, FlareVM, and an Ubuntu management client.

### Firewall Rules

Firewall rules in pfSense control traffic between subnets and external destinations, allowing only necessary communication. Initially, the ruleset was permissive to establish baseline functionality, but it has since evolved to adopt a more restrictive approach:

**Zero-Trust Principles**: Traffic is blocked by default unless explicitly allowed, reducing exposure and minimizing the attack surface.

**OpenVPN** is configured on pfSense to provide secure remote access to the lab environment, allowing for seamless management and interaction with systems from any location.

**Capabilities**:

- Encrypted VPN tunnels protect all data in transit.
- Remote access to internal systems via RDP or browser-based interfaces.
- Clipboard functionality supported by RDP, not possible with noVNC provided by Proxmox.

## Active Directory

**Active Directory** is a cornerstone of enterprise environments, enabling centralized management of users, computers, and policies. It enforces configurations via Group Policy Management and is hosted on a Windows Server acting as the Domain Controller.

### Components

A **Windows Server 2019** instance is the Active Directory Domain Controller, DHCP server, and DNS server for the lab's internal network. It manages authentication, resource access, and network services, forming the backbone of the Active Directory environment.

**Two Windows Clients** - one running Windows 10 and another running Windows 11 - are joined to the domain. This setup enables testing attacks and defenses on different operating systems, highlighting varied behavior and security features.

## BadBlood

**BadBlood** mimics the complexity of enterprise environments by seeding Active Directory with realistic objects, configurations, and intentional vulnerabilities. I have configured BadBlood to create 250 users, 50 groups, and 10 computers in addition to the 3 Windows VMs listed above.
BadBlood introduces misconfigurations, weak policies, and exposed credentials, making it ideal for exploring vulnerabilities and threat emulation.

[Download BadBlood on GitHub](https://github.com/)  

## SIEM Engineering

I'm focusing on Endpoint and Identity logs since most attacks now target these as security becomes less network-centric. Security Onion is my favorite option for a SIEM (I tried to find a better option and couldn't!) as it is open source and includes the ELK stack and Wazuh, preconfiguring them on a single host.
Security Onion is set up in standalone mode with Elastic Agents as the primary source of logs while Zeek and PCAP are disabled to optimize performance since no network traffic is captured. An additional monitoring adapter, though not in use, is required for the system to remain operational.

### Setup
The following highlights how I set up Security Onion specific to my environment.

- **Download the ISO and configure VM**: Standalone mode
- **Disable Network Detection**: No Zeek or PCAP services running.
- **Elastic Agents**: Installed on Windows and Linux endpoints.
- **Network Configuration**: Mapped Security Onion to a static DHCP address in pfSense.

### Troubleshooting

Identifying reliable fields in Kibana to aid in investigations exposed the following issues:

- Increasing Logstash's batch size to 500 for increased throughput between Elastic Agents and Elasticsearch
- Setting the hosts' timezone and NTP server appropriately resolved timestamps that were 3 hours ahead of Security Onion's system time which had prevented them from being ingested into Elasticsearch

Key logs for debugging include:

- **Logstash logs**: `/opt/so/log/logstash/logstash.log`
- **Elasticsearch logs**: `/opt/so/log/elasticsearch/securityonion.log`

## Digital Forensics

**Velociraptor** collects and analyzes forensic artifacts from Windows and Linux systems with access to the disk and memory. While Security Onion shows activity logs, Velociraptor provides access to the data at rest. This makes it possible to detect anti-forensics techniques and extract detailed information from the file system.

### Data Sources

- **Memory Dumps**: Capture memory images for process inspection.
- **Master File Table (MFT)**: Review file timestamps, changes, and evidence of tampering.
- **USN Journal**: Track file creations, deletions, and changes.
- **Registry Hives**: Analyze Windows system settings, user activity, and malware persistence mechanisms.
- **Other Disk Artifacts**: Prefetch files, browser history, event logs, ShimCache, and AmCache for building timelines and finding traces of malicious activity.

### Installation

Velociraptor runs on a VM running the **Ubuntu Server** ISO.

**Key installation steps**:

- Downloaded the Velociraptor binary and followed the configuration prompts from Velociraptor.app.
- Changed the GUI bind-address in server.config.yaml to the machine's IP (172.18.1.20) instead of its loopback address, enabling access to the web interface over the VPN tunnel via HTTPS port 8889.
- Deployed agents to Windows and Linux machines using the preconfigured installation file.

I opted out of automatic collection to optimize performance. Instead, I manually initiate artifact collection as needed on specific endpoints.

---
## Malware Analysis 

**FlareVM** is my Windows-based malware analysis environment. It's packed with tools for both static and dynamic analysis. Setup instructions are available at my Medium article:

[Turning Windows 11 into a Malware Analysis Sandbox](https://medium.com/@logan.flecke/installing-the-flare-vm-for-malware-analysis-36a4a302ca41)  

Some key tools I use:
- **IDA Free / Ghidra**: Reverse engineering
- **x64dbg**: Debugging
- **PE Studio**: Inspecting Windows binaries
- **Wireshark**: Analyzing network traffic

I will detonate malware on the Active Directory subnet and then analyze the droppers and payloads in the FlareVM. Two methods to transport files to the FlareVM include:
1. Password-protected .zip files via an RDP connection from the FlareVM.
2. Copy the file from Velociraptor following the collection of a disk image

## Adversary Emulation

**Atomic Red Team** by **Red Canary** is an open-source framework for testing security controls. It executes adversary techniques based on the MITRE ATT&CK framework, allowing for targeted simulations of cyberattacks.
Why Use It:
- Create realistic artifacts for investigations.
- Test defenses against individual techniques or multi-step attack chains.
- Customize technique sequences in CSV files.

This tool helps me practice analyzing attack behaviors and improves my understanding of detection strategies.

[Download Atomic Red Team on GitHub](https://github.com/)  

---

Lessons Learned:
1. Always identify issues after installation to ensure a clean install. Use .log files to troubleshoot problems
2. Understand concepts and design implications before implementation
3. Document constantly to show growth, identify gaps, and solidify knowledge, skills, and abilities

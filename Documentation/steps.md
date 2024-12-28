# **Steps to Set Up the Lab**  

## **1. Operating System**  
Prepare the underlying operating system for hosting the hypervisor.  

## **2. Hypervisor**  

- **Type**:  
  1. Install and configure Proxmox on bare-metal hardware.  
  2. Set up virtualization for multiple operating systems.  
  3. Optimize performance for virtual machines (VMs).  

- **Networking**:  
  - Map virtual networks (vnets) to physical network interfaces.  
  - Disable firewalls on LAN-facing `vmbr` bridges to allow unrestricted internal traffic.  

## **3. Firewall**  

- **VPN**:  
  - Configure OpenVPN to allow secure remote access from the home network.  
  - Enable clipboard functionality for interactions with VMs (e.g., malware analysis).  
  - Consider risks associated with using clipboard functionality in malware analysis environments.  
  - Understand OpenVPN's client/server model, subnet configurations, and overall setup.  

- **Rules**:  
  - Determine and implement the necessary open ports to support services.  

- **DHCP**:  
  - Assign static mappings to specific machines where needed.  

## **4. Active Directory**  

- **Installing VMs**:  
  - Locate and download required ISOs.  
  - Install drivers and configure Proxmox VM settings.  
  - Enable RDP for administrative access.  

- **Installing Active Directory, DNS, DHCP**:  
  - Deploy Active Directory services.  
  - Enable auditing to capture security-related events.  

- **Joining Clients to Domain**:  
  - Configure clients to join the domain.  
  - Set the Domain Controller (DC) as the DNS server.  

- **Future Plans**:  
  - Implement Kerberos configurations for secure authentication.  

## **5. Malware Analysis**  

- **Clone or Install a Windows VM**:  
  - Prepare isolated environments for malware analysis.  

- **Disable Defender**:  
  - Disable Windows Defender to prevent interference during testing.  

- **Perform Additional Setup**:  
  - Make environment-specific adjustments for analysis.  

## **6. Security Onion**  

- **Download ISO and Configure VM**:  
  - Install and set up Security Onion for monitoring and detection.  

- **Disable Unnecessary Services**:  
  - Deactivate components like Suricata, Zeek, and IDSTools based on lab requirements.  

- **Elastic Agents**:  
  - Install Elastic Agents for data collection and monitoring.  
  - Adjust time zone settings to ensure accurate logging.  

## **7. Velociraptor**  

- **Install VM and Service**:  
  - Deploy Velociraptor on a dedicated VM and set it up as a service.  

- **Deploy Agents**:  
  - Install and configure Velociraptor agents on endpoints for data collection.  

## **8. Replicate Vulnerable Enterprise**  

- **Install and Run BadBlood**:  
  - Use BadBlood to populate Active Directory with realistic but intentionally vulnerable configurations.  

## **9. Adversary Emulation**  

- **Install and Run Atomic Red Team**:  
  - Exclude directories from security tools to avoid interference.  
  - Install Atomic Red Team on the Domain Controller with a specified path.  
  - Run `Invoke-AtomicTest` for individual tests or use CSV files to execute multi-step attack chains.  

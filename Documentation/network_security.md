# Network Security

Securing the lab network is a priority to ensure controlled access, realistic segmentation, and effective isolation of systems. Using **pfSense**, I’ve implemented a robust setup to manage traffic, enforce security policies, and enable remote access.

## **pfSense**

pfSense serves as the foundation for network security in the lab, offering advanced routing, firewall, and VPN capabilities.

### **Network Segmentation**

The lab network is divided into distinct subnets, each serving a specific purpose:

- **Internal Network**: Hosts core systems like Active Directory and Windows client machines.
- **DMZ**: Contains public-facing or intentionally vulnerable systems for attack simulations.
- **DFIR Subnet**: Dedicated to forensics and analysis tools, including Velociraptor, Security Onion, FLARE, and an Ubuntu management client.

### **Firewall Rules**

Firewall rules in pfSense control traffic between subnets and to external destinations, allowing only necessary communication. Initially, the ruleset was permissive to establish baseline functionality, but it has since evolved to adopt a more restrictive approach:

- **Least Privilege**: Traffic is permitted only for specific services required by the systems, such as RDP to the Internal subnet or web access to system consoles.
- **Zero-Trust Principles**: Traffic is blocked by default unless explicitly allowed, reducing exposure and minimizing attack surface.

## **OpenVPN**

OpenVPN is configured on pfSense to provide secure remote access to the lab environment. This allows for seamless management and interaction with lab systems from any location.

**Capabilities**:
    
- Encrypted VPN tunnels protect all data in transit.
- Remote access to internal systems via RDP or browser-based interfaces.
- Secure access to pfSense and other administrative systems on the DFIR subnet.

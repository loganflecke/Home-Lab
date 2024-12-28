# Active Directory

Active Directory (AD) is a cornerstone of enterprise environments, enabling centralized management of users, computers, and policies. It enforces configurations via Group Policy Management and is hosted on a Windows Server acting as the Domain Controller (DC). My lab uses Active Directory to simulate real-world setups for testing both offensive and defensive cybersecurity techniques.
## Components

### **Windows Server 2019**

A Windows Server 2019 instance functions as the Domain Controller, DHCP, and DNS server for the lab's internal subnetwork. It manages authentication, resource access, and network services, forming the backbone of the Active Directory environment.

### **Windows Clients**

Two client machines—one running Windows 10 and another running Windows 11—are joined to the domain. This setup provides opportunities to test attacks and defenses on different operating systems, highlighting variations in behavior and security features.
## Tools and Enhancements

### **BadBlood**

To mimic the complexity of enterprise environments, I use **BadBlood**, a tool that seeds Active Directory with realistic objects, configurations, and intentional vulnerabilities.

- **Configuration Details**:
    - **Users**: 250
    - **Groups**: 50
    - **Computers**: 12 (including the Domain Controller)

BadBlood introduces misconfigurations, weak policies, and exposed credentials, making it ideal for exploring vulnerabilities, privilege escalation, and threat emulation.

**Download**: [BadBlood on GitHub](https://github.com/davidprowe/BadBlood)

---

### **Atomic Red Team**

**Atomic Red Team** by Red Canary is an open-source framework for testing security controls. It executes adversary techniques based on the **MITRE ATT&CK framework**, allowing for targeted simulations of cyberattacks.

- **Why I Use It**:
    - Creates realistic attack artifacts for investigation.
    - Tests defenses against individual techniques or multi-step attack chains.
    - Supports customization with technique sequences in CSV files.

This tool helps me practice analyzing attack behaviors and improves my understanding of detection strategies.

**Download**: [Atomic Red Team on GitHub](https://github.com/redcanaryco/atomic-red-team)

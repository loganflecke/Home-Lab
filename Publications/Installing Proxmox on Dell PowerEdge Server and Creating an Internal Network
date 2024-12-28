# Installing Proxmox on Dell PowerEdge Server and Creating an Internal Network  

This guide will walk you through installing Proxmox on a Dell PowerEdge server and setting up an internal network for a home lab environment.  

---

## **Prerequisites**  

Before starting, ensure you have:  
1. A Dell PowerEdge server (e.g., R710, R720).  
2. A bootable USB drive with the Proxmox ISO.  
3. Access to the server's BIOS and boot menu.  

---

## **Step 1: Preparing the Server**  

### **1.1 Updating Firmware**  
- Download the latest firmware updates from Dell's support website.  
- Create a bootable USB with the firmware update tool.  
- Reboot the server and update firmware via the boot menu.  

### **1.2 RAID Configuration**  
- Access the RAID controller during startup (e.g., `Ctrl + R` for Dell servers).  
- Configure your RAID array based on your storage needs (e.g., RAID 5 for redundancy).  
- Initialize the RAID array before proceeding.  

---

## **Step 2: Installing Proxmox VE**  

### **2.1 Boot from USB**  
1. Insert the Proxmox ISO bootable USB drive into the server.  
2. Access the boot menu (e.g., `F11` or `F12` for Dell servers).  
3. Select the USB drive as the boot device.  

### **2.2 Installation Steps**  
1. Select "Install Proxmox VE" from the menu.  
2. Agree to the license agreement.  
3. Select the target drive for installation (e.g., your RAID array).  
4. Configure networking (e.g., set a static IP address).  
5. Complete the installation and reboot the server.  

---

## **Step 3: Initial Configuration**  

### **3.1 Access the Web Interface**  
1. Open a browser and navigate to the server's IP address (e.g., `https://<server-ip>:8006`).  
2. Log in with the root credentials created during installation.  

### **3.2 Update Proxmox**  
Run the following commands to update Proxmox:  
```bash
apt update && apt full-upgrade -y  
pveupgrade  
```  

---

## **Step 4: Setting Up an Internal Network**  

### **4.1 Creating Virtual Networks**  
1. Navigate to `Datacenter > Nodes > <Server Name> > Network` in the Proxmox web interface.  
2. Add a new Linux Bridge for each internal network (e.g., `vmbr1`, `vmbr2`).  
3. Assign IP addresses to the bridges for management purposes.  

### **4.2 Configuring VMs**  
1. Create virtual machines in Proxmox.  
2. Attach VMs to the appropriate bridge for network segmentation.  

### **4.3 Disabling Firewall on LAN Bridges**  
To avoid connectivity issues in the lab environment, disable the firewall for internal bridges.  
1. Go to `Datacenter > Firewall > Options`.  
2. Turn off the firewall for internal bridges like `vmbr1` and `vmbr2`.  

---

## **Step 5: Adding Open vSwitch (Optional)**  

To enable advanced networking features like VLANs or port mirroring, install and configure Open vSwitch:  
```bash
apt install openvswitch-switch  
```  
- Replace Linux bridges with OVS bridges in `/etc/network/interfaces`.  
- Configure VLANs or port mirroring as needed.  

---

## **Conclusion**  

You’ve successfully installed Proxmox on a Dell PowerEdge server and set up an internal network. This configuration provides a foundation for a robust home lab, ideal for testing, forensics, and cybersecurity experiments.  

For further details or troubleshooting, refer to Proxmox documentation or Dell support resources.  

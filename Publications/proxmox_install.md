# **Installing Proxmox on Dell PowerEdge Server and Creating an Internal Network**

## **Overview:**
This guide walks through the steps of installing Proxmox on a Dell PowerEdge server and creating an internal network with a pfSense firewall connecting to internal hosts. This is useful for setting up a home lab or learning Proxmox for virtualization.

## **Components:**
- **Server:** Dell PowerEdge R730 with 2 14-core CPUs, 32GB memory, and 1.8TB storage
- **Operating System:** Proxmox VE 8.2 [Proxmox Download Link](https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso)

---

## Installing Proxmox on the Server

**Preparing the USB:**
1. Ensure the USB drive is properly formatted to FAT32 using tools like **Ventoy**, **Rufus**, or **Etcher**.
   - **Ventoy** allows multiple ISOs on the same device and is recommended for the setup.
   - Use the **GPT partitioning scheme** (recommended for UEFI compatibility).
   
2. **Formatting the USB:**
   - On a Windows system, use `diskpart`:
     - Open Command Prompt as Administrator.
     - Run `diskpart`, `list disk`, `select disk <disk number>`, and `clean` to wipe the USB drive.
   
   - After the drive is wiped, use **Ventoy** to format it with FAT32 and GPT.

---

## Installing the OS

1. **Booting the Server:**
   - Insert the USB into the Dell PowerEdge R730, and press **F10** to enter the Lifecycle Controller.
   - Go to **System Setup > System BIOS > Boot Settings** and enable **UEFI**, then disable **BIOS**.
   
2. **Set the Boot Sequence:**
   - Set the USB drive at the end of the boot sequence.
   - Enable DHCP to let the router provide the server with an IP address. If no IP is provided, reboot and retry.
   
3. **Proxmox Installation:**
   - After setting DHCP, follow the prompts to install Proxmox on the server.

---

## Creating an Internal Network (LAN)

1. **Verify Network Connectivity:**
   - After Proxmox installation, use `ip a` and `ping google.com` to verify that the server has an IP address and internet connection.

2. **Setting Up Virtual Network Adapters:**
   - To create a virtual network, modify `/etc/network/interfaces`:
     - Set `eno1` (physical adapter) to **manual**.
     - Set `vmbr0` (virtual adapter) to **static** with the IP address `10.0.0.79/24` and gateway `10.0.0.1`.
     - Add `bridge-ports eno1` to link the virtual adapter to the physical one.

   ```bash
   # /etc/network/interfaces
   auto lo
   iface lo inet loopback
   auto eno1
   iface eno1 inet manual
   auto vmbr0
   iface vmbr0 inet static
       address 10.0.0.79/24
       gateway 10.0.0.1
       bridge-ports eno1
       bridge-stp off
       bridge-fd 0
   ```

3. **Access Proxmox Web Interface:**
   - Open a browser and go to `https://<server ip>:8006/` to access the Proxmox web interface.
   - Log in with the root account and password set during installation.

4. **Creating Virtual Machines (VMs):**
   - Create a **Kali Linux** VM connected to `vmbr0` (WAN).
   - Create an **Ubuntu desktop** VM and connect it to a new network adapter (LAN).
   - Create a **pfSense firewall** VM to manage the WAN and LAN networks.

---

## pfSense Firewall Setup

1. **Creating the LAN Network:**
   - In Proxmox, go to **Create > Linux Bridge** to create a new virtual network adapter for the internal network.
   - Optionally enable **VLAN aware** if you plan to use VLANs to segment the network further.
   
2. **Configure pfSense:**
   - Set up **vmbr0** for WAN and **vmbr1** for LAN in pfSense.
   - This allows the internal VMs to connect to the internet via the firewall.

3. **Finalize Configuration:**
   - After pfSense is installed, configure network adapters (`vmbr0` for WAN and `vmbr1` for LAN).
   - Apply configuration in Proxmox to enable the new settings across all VMs without rebooting.

---

## Final Setup

1. **Connect Internal Machines:**
   - With the internal network set up, you can add more VMs, test attacks, set up detection mechanisms, or expand your lab as needed.

2. **Summary:**
   - You've successfully set up Proxmox on a Dell PowerEdge server and created an internal network with a pfSense firewall managing the connection between LAN and WAN.

---

**Connect with me:** [LinkedIn Profile](https://www.linkedin.com/in/loganflecke/)

# Steps

## 1. Operating System

## 2. Hypervisor

**Type**: 

Something like 1, 2, 3 where this one runs on bare metal hardware

**Networking**: 

Mapping vnets to physical

Disabing firewall on LAN vmbr's

## 3. Firewall

**VPN**: 

Allowing control from home network (outside proxmox GUI)

Support copy paste

Risks with malware analysis VM

How OpenVPN works with client/server, subnets, and configurations

**Rules**:

What ports need to be open

**DHCP**:

What machines are have a static mapping

## 4. Active Directory

**Installing VMs**:

Finding ISOs

Drivers

Proxmox configs

Enable RDP

**Installing Active Directory, DNS, DHCP**:

Enable Auditing

**Joining clients to domain**:

Joining computer

Setting DC and DNS server

**Future**:

Configure Kerberos

## 5. Malware Analysis

**Clone or Install a Windows VM**:

**Disable Defender**:

**Do something else**:

## 6. Security Onion

**Download ISO and configure VM**:

**Disable unnecessary services**:

Suricata, Zeek, IDSTools

**Elastic Agents**:

Installation

Fix Time Zone

## 7. Install Velociraptor

Install VM

Install service

**Deploy Agents**:

## 8. Replicate Vulnerable Enterprise

**Install and Run Badblood**:

## 9. Adversary Emulation

**Install and Run Atomic Red Team**:

Exclude directory

Installation on Domain Controller

Specify Install Path

Run Invoke-AtomicTest

Use Adversary CSV files
#!/bin/python3

import json
import subprocess

vm_bridges = {
	"vmbr1":["101","102","104","105","106","107","108"],
	"vmbr2":["102","103"],
	"vmbr3":["102","107"]
}

def iterate_through(setting):
	print(f"Executing command 'qm set <vmid> --net0 virtio,bridge=<vmbr#>,firewall={setting}'")
	for bridge, vms in vm_bridges.items():
		print(f"Bridge: {bridge}")
		for vm in vms:
			command = f"qm set {vm} --net0 virtio,bridge={bridge},firewall={setting}"
			print(f"{vm}")

			try:
				result = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
				# print(f"{result.stdout}")
			except subprocess.CalledProcessError as e:
				print(f"Error executing command for VM {vm} on Bridge {bridge}:\n{e.stderr}")

# turn firewall on
iterate_through(1)

# turn firewall off
iterate_through(0)

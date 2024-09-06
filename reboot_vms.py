#!/bin/python3

import json
import subprocess

vms = ["101","102","103","104","105","106","107","108"]

def iterate_through():
	print(f"Executing command 'qm reboot <vmid>'")
	for vm in vms:
		command = f"qm reboot {vm}"
		print(f"{vm}")

		try:
			result = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
			# print(f"{result.stdout}")
		except subprocess.CalledProcessError as e:
			print(f"Error executing command for VM {vm}:\n{e.stderr}")

# turn firewall on
iterate_through()

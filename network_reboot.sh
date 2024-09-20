#!/bin/dash

# Script to restart networking and trigger DHCP to give the server an IP address
# Used when Proxmox WAN network adapter is configured with DHCP
# Access to the router's DHCP leases is required

NETWORKRECONNECT=/root/network_reboot.log
date > $NETWORKRECONNECT

function run_fix () {
	systemctl restart networking
	echo "	Networking restarted" >> $NETWORKRECONNECT
	sleep 10
	dhclient -r vmbr0
	sleep 20
	dhclient vmbr0
	echo "	vmbr0 acquired new IP address" >> $NETWORKRECONNECT
	sleep 20
	ifreload -a
	echo "	Fix completed" >> $NETWORKRECONNECT
}

function check_ping () {
	echo "Testing connection..." >> $NETWORKRECONNECT
	ping -c 1 google.com > /dev/null 2>$1
	return $?
}

i=0
while [ $i -le 5 ] 
do
	$trial = $i+1
	echo "Running fix $trial" >> $NETWORKRECONNECT
	run_fix

	if check_ping; then
		echo "Fix successful" >> $NETWORKRECONNECT
		break
	else
		echo "Trying again..." >> $NETWORKRECONNECT
	fi

	sleep 5
	i = $((i+1))
done

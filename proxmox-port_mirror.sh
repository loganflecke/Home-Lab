#!/bin/bash

# proxmox-port_mirror.sh
# mirror all traffic on vmbr1 to the interface used by Security Onion for monitoring, tap107i1
# output all data to a log file

PORTMIRRORLOG=/root/proxmox-port_mirror.log

ports_mirroring=("vmbr1" "vmbr2")
output_interface="tap107i1" # security onion monitor interface

date > $PORTMIRRORLOG
echo "#######################" >> $PORTMIRRORLOG
echo "Mirror port set to ${ports_mirroring[@]}" >> $PORTMIRRORLOG

# Uncomment the following to confirm ports and interfaces as the command is run

#function get_input {
#	while true; do
#	read -p "$1" yn >> $PORTMIRRORLOG
#	case $yn in
#		[yY] ) echo Proceeding...;
#			break;;
#		[nN] ) echo Exiting...;
#			exit;;
#		* ) echo Invalid response;;
#	esac
#	done
#}
#
#message="Mirror port set to ${ports_mirroring[@]}. Continue? [Y/n]"
#get_input "$message"
#message="Output interface set to $output_interface. Continue? [Y/n]"
#get_input "$message"

echo "Clearing any existing mirror..." >> $PORTMIRRORLOG

for vm_bridge in "${!ports_mirroring[@]}"; do
	ovs-vsctl clear bridge $ports_mirroring mirrors
done

for vm_bridge in "${!ports_mirroring[@]}"; do
	mirror_name="span$((vm_bridge+1))"
	echo "Creating $mirror_name mirror for ${ports_mirroring[$vm_bridge]} bridge to $output_interface..." >> $PORTMIRRORLOG

	ovs-vsctl -- --id=@p get port $output_interface \
	-- --id=@m create mirror name=$mirror_name select-all=true output-port=@p \
	-- set bridge ${ports_mirroring[$vm_bridge]} mirrors=@m >> $PORTMIRRORLOG
done

echo "Showing existing mirrors..." >> $PORTMIRRORLOG

ovs-vsctl list Mirror >> $PORTMIRRORLOG

echo "########################" >> $PORTMIRRORLOG

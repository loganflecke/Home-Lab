#!/bin/bash

# proxmox-port_mirror.sh
# mirror all traffic on given bridge ports to the interface used by Security Onion for monitoring, tap107i1
# output all data to a log file

# inspiration comes from "vext" at https://vext.info/2018/09/03/cheat-sheet-port-mirroring-ids-data-into-a-proxmox-vm.html

PORTMIRRORLOG=/root/proxmox-port_mirror.log

mirror_ports=("vmbr1" "vmbr2")
output_interface="tap107i1" # security onion monitor interface

date > $PORTMIRRORLOG
echo "#######################" >> $PORTMIRRORLOG
echo "Mirror port set to ${mirror_ports[@]}" >> $PORTMIRRORLOG

# Uncomment the following to ask for confirmation on what ports to mirror and what interface to output to
#############################################
# function get_input {
# 	while true; do
# 	read -p "$1" yn >> $PORTMIRRORLOG
# 	case $yn in
# 		[yY] ) echo Proceeding...;
# 			break;;
# 		[nN] ) echo Exiting...;
# 			exit;;
# 		* ) echo Invalid response;;
# 	esac
# 	done
# }
# get_input "Mirror port set to ${mirror_ports[@]}. Continue? [Y/n]"
# get_input "Output interface set to $output_interface. Continue? [Y/n]"
#############################################

echo "Clearing any existing mirror..." >> $PORTMIRRORLOG

for i in "${!mirror_ports[@]}"; do
	ovs-vsctl clear bridge $mirror_ports mirrors
done

# Create mirror on each bridge listed in mirror_ports
for i in "${!mirror_ports[@]}"; do
	mirror_name="span$((i+1))"
	echo "Creating $mirror_name mirror for ${mirror_ports[$i]} bridge to $output_interface..." >> $PORTMIRRORLOG

	ovs-vsctl -- --id=@p get port $output_interface \
	-- --id=@m create mirror name=$mirror_name select-all=true output-port=@p \
	-- set bridge ${mirror_ports[$i]} mirrors=@m >> $PORTMIRRORLOG
done

echo "Showing existing mirrors..." >> $PORTMIRRORLOG

ovs-vsctl list mirror >> $PORTMIRRORLOG

echo "########################" >> $PORTMIRRORLOG

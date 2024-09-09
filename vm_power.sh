#!/bin/dash

if [ $1 != "shutdown" ] && [ $1 != "reboot" ]; then
	echo "Invalid argument: $1. Use 'shutdown' or 'reboot'."
	exit 1
fi

for vmid in $(qm list | awk '$3 ~ /running/ && $4 ~ /l/i {print $1}'
do
	echo "$1 vm $vmid"
	qm exec $vmid "$1 -h now"
done

#!/bin/bash

# Log file to track the script's actions
LOGFILE=/root/network_reboot.log
date > $LOGFILE

# Function to test internet connectivity by pinging google.com twice
function test_ping {
    echo "Testing internet connectivity by pinging google.com twice..." >> $LOGFILE
    ping -c 2 google.com > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Ping successful! Internet connection is working." >> $LOGFILE
        exit 0
    else
        echo "Ping failed. No internet connection." >> $LOGFILE
    fi
}

# Loop the whole process 5 times if necessary
for attempt in {1..5}; do
    echo "" >> $LOGFILE
    date >> $LOGFILE
    echo "Attempt $attempt to fix networking..." >> $LOGFILE
    
    # Restart networking service
    echo "Restarting networking service..." >> $LOGFILE
    systemctl restart networking
    if [ $? -eq 0 ]; then
        echo "Successfully restarted networking." >> $LOGFILE
    else
        echo "Failed to restart networking." >> $LOGFILE
    fi

    # Sleep for 15 seconds after restarting networking
    sleep 15

    # Ping to check if network is already up
    test_ping

    # Reload network interfaces
    echo "Reloading network interfaces..." >> $LOGFILE
    ifreload -a
    if [ $? -eq 0 ]; then
        echo "Successfully reloaded network interfaces." >> $LOGFILE
    else
        echo "Failed to reload network interfaces." >> $LOGFILE
    fi

    # Sleep for 5 seconds after restarting networking
    sleep 5

    # Ping to check if reloading interfaces fixed the connection
    test_ping

    # Release the IP address for vmbr0
    echo "Releasing old IP address for vmbr0..." >> $LOGFILE
    dhclient -r vmbr0
    if [ $? -eq 0 ]; then
        echo "Successfully released old IP address for vmbr0." >> $LOGFILE
    else
        echo "Failed to release old IP address for vmbr0." >> $LOGFILE
    fi

    # Sleep for 5 seconds after restarting networking
    sleep 5

    # Ping to check if the release of the IP address affects connectivity
    test_ping

    # Acquire a new IP address for vmbr0
    echo "Acquiring new IP address for vmbr0..." >> $LOGFILE
    dhclient vmbr0
    if [ $? -eq 0 ]; then
        echo "Successfully acquired new IP address for vmbr0." >> $LOGFILE
    else
        echo "Failed to acquire new IP address for vmbr0." >> $LOGFILE
    fi

    # Sleep for 10 seconds after acquiring new IP
    sleep 10

    # Final ping test after acquiring the new IP
    test_ping

    echo "Attempt $attempt completed without successful ping. Retrying..." >> $LOGFILE
done

echo "All attempts completed but no successful ping. Please check network settings." >> $LOGFILE
exit 1

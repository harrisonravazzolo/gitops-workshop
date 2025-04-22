#!/bin/bash

PRIMARY_DNS="1.1.1.1"
SECONDARY_DNS="1.0.0.1"

# Get the name of the current active network interface
ACTIVE_INTERFACE=$(networksetup -listallnetworkservices | grep -v "An asterisk" | sed -n '2p')

# Check if we got a valid interface
if [ -z "$ACTIVE_INTERFACE" ]; then
  echo "Error: Could not determine active network interface."
  echo "Available interfaces:"
  networksetup -listallnetworkservices | grep -v "An asterisk"
  exit 1
fi

echo "Setting DNS servers for $ACTIVE_INTERFACE to $PRIMARY_DNS and $SECONDARY_DNS..."

# Set the DNS servers for the active interface
sudo networksetup -setdnsservers "$ACTIVE_INTERFACE" $PRIMARY_DNS $SECONDARY_DNS

# Flush the DNS cache
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

echo "DNS servers updated successfully!"
echo "Current DNS settings:"
networksetup -getdnsservers "$ACTIVE_INTERFACE"
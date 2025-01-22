#!/bin/bash

# Enable pfctl
sudo pfctl -e

# Check and display the current status
status=$(sudo pfctl -s info | grep "Status:")
echo "Current PF Status: $status"

# Path to the pf.conf file
PF_CONF="/etc/pf.conf"
BACKUP_PATH="/etc/pf.conf.bak"

# Rule to be added
RULE="block drop out proto tcp from any to any port 853"

# Make a backup of the pf.conf file if not already done
if [ ! -f "$BACKUP_PATH" ]; then
    echo "Creating a backup of $PF_CONF at $BACKUP_PATH"
    sudo cp "$PF_CONF" "$BACKUP_PATH"
else
    echo "Backup already exists at $BACKUP_PATH"
fi

# Check if the rule already exists
if ! sudo grep -qF "$RULE" "$PF_CONF"; then
    echo "Rule not found in $PF_CONF. Adding rule..."
    sudo bash -c "echo '$RULE' >> $PF_CONF"
else
    echo "Rule already exists in $PF_CONF. No changes made."
fi

# Reload the pf.conf to apply changes
sudo pfctl -f "$PF_CONF"
echo "PF configuration reloaded."

#!/bin/bash

# Function to trigger webhook
trigger_webhook() {
    # Replace 'YOUR_WEBHOOK_URL' with your actual webhook URL
    webhook_url="https://hooks.slack.com/services"

    # Run Nmap scan and grep necessary information
    nmap_output=$(nmap -sP 192.168.11.0/24 | grep -E 'Nmap scan report|MAC Address|Host is up')

    # Prepare formatted message
    message="Nmap scan report:\n"
    while read -r line; do
        if [[ $line =~ Nmap\ scan\ report\ for\ ([^ ]+).* ]]; then
            ip_address="${BASH_REMATCH[1]}"
        fi

        if [[ $line =~ MAC\ Address:\ (.*) ]]; then
            mac_address="${BASH_REMATCH[1]}"
            message="$message$ip_address , $mac_address\n"
        fi
    done <<< "$nmap_output"



    # Extract number of hosts up
    hosts_up=$(echo "$nmap_output" | grep -c "Host is up")
    message="$message\nTotal hosts up: $hosts_up"


    # Send the formatted message via webhook
    curl -X POST -H 'Content-Type: application/json' -d "{\"text\":\"$message\"}" $webhook_url
}

# Trigger webhook function
trigger_webhook

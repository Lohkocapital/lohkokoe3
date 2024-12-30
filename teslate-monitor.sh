#!/bin/bash

# Variables required for notification via Discord
# MESSAGE="Houston! We have a problem!"
BOT_TOKEN="MTI3NjI4MjgwNzExNDUzMDg1OQ.GzIGOO.e_hl8_0KdfWaOEbK5hAyY9DYFlS6p8iM_xwjrc"
CHANNEL_ID="1276285269326430329"

# Define the servers and ports
declare -A SERVERS
SERVERS=(
    ["teslate|sami@nanops.cloud:W3bkaksi"]="https://teslamate.teslate.cloud/grafana/login"
    ["superset"]="http://salminen.io:8088/login/"
#    ["teslamate-legacy"]="http://salminen.io:4000"
#    ["teslamate-grafana-legacy"]="http://salminen.io:3000/login"
    ["homeassistant"]="http://salminen.io:8123"
)

# Define log file location
LOG_FILE="/home/sami/monitor/service_monitor.log"
EMAIL_RECIPIENT="sami@nanops.cloud"

# Function to check service availability
check_service() {
    local name=$1
    local url=$2
    local credentials=""

    # Check if credentials are included in the name
    if [[ $name == *"|"* ]]; then
        credentials=$(echo "$name" | cut -d'|' -f2)
        name=$(echo "$name" | cut -d'|' -f1)
        # echo "$(date) Inside chopping function: CREDENTIALS: $credentials" >> $LOG_FILE
        # echo "$(date) Inside chopping function:: NAME: $name" >> $LOG_FILE
    fi

    # Use curl with or without credentials based on the presence of credentials
    if [[ -n $credentials ]]; then
    # if curl -u "$credentials" -s --head --request GET "$url" | grep "200 OK" > /dev/null; then
        # Capture the HTTP response
        response=$(curl -u "$credentials" -s -i --request GET "$url")

        # Log the full HTTP response
        # echo "$(date) HTTP Response: $response" >> $LOG_FILE

        # Check if the response contains "200 OK"
        if echo "$response" | grep "200" > /dev/null; then
            echo "$(date) OK: $name is UP" >> $LOG_FILE
        else
            echo "$(date) ALERT: $name at $url is DOWN" >> $LOG_FILE
            MESSAGE="Houston! We have a problem with $name at $url"
            curl -X POST "https://discord.com/api/v10/channels/${CHANNEL_ID}/messages" -H "Authorization: Bot ${BOT_TOKEN}" -H "Content-Type: application/json" -d "{\"content\": \"${MESSAGE}\"}"
            echo "$(date) ALERT: $name at $url is DOWN" | mail -s "ALERT - SERVICE DOWN: $name at $url not responding" "$EMAIL_RECIPIENT"
        fi
    else
        if curl -s --head --request GET "$url" | grep "200" > /dev/null; then
            echo "$(date) OK: $name is UP" >> $LOG_FILE
        else
            echo "$(date) ALERT: $name at $url is DOWN" >> $LOG_FILE
            MESSAGE="Houston! We have a problem at $url"
            curl -X POST "https://discord.com/api/v10/channels/${CHANNEL_ID}/messages" -H "Authorization: Bot ${BOT_TOKEN}" -H "Content-Type: application/json" -d "{\"content\": \"${MESSAGE}\"}"
            echo "$(date) ALERT: $name at $url is DOWN" | mail -s "ALERT - SERVICE DOWN: $name at $url not responding" "$EMAIL_RECIPIENT"
        fi
    fi
}

# check_service
# Main script loop
for service in "${!SERVERS[@]}"; do
    check_service "$service" "${SERVERS[$service]}"
done

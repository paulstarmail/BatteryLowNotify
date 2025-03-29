#!/bin/bash

# Variable to track if the notification has already been shown
notified=false

# Loop to check battery percentage every 30 seconds
while true; do
    # Get the battery percentage using upower
    battery_percentage=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -i "percentage" | awk '{print substr($2, 1, length($2)-1)}')

    # Check if the battery percentage is less than or equal to 20 and no notification has been shown yet
    if [ "$battery_percentage" -le 20 ] && [ "$notified" = false ]; then
        # Display a warning pop-up
		notify-send --urgency=critical --expire-time=0 "Battery Alert" "Battery is at $battery_percentage%. Please plug in your charger."
		
        # Set the flag to true so the notification won't be shown again
        notified=true
    fi

    # Wait for 30 seconds before checking again
    sleep 30
done


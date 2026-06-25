#!/bin/bash

# Variable to track if the critical notification has already been shown during discharge
notified=false

# Loop to check battery percentage and state every 30 seconds
while true; do
    # Get the battery percentage (strips the % sign)
    battery_percentage=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -i "percentage" | awk '{print $2}' | tr -d '%')

    # Get the battery state (charging, discharging, fully-charged, etc.)
    battery_state=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -i "state" | awk '{print $2}')

    # Debugging lines (Optional: uncomment to see output in terminal)
    # echo "State: $battery_state | Percentage: $battery_percentage%"

    # Only trigger notification if discharging, <= 20%, and not already notified
    if [ "$battery_state" = "discharging" ]; then
        if [ "$battery_percentage" -le 20 ] && [ "$notified" = false ]; then
            # Display a warning pop-up
            notify-send --urgency=critical --expire-time=0 "Battery Alert" "Battery is low at $battery_percentage%. Please plug in your charger."
            espeak "Battery, low."

            # Set the flag so it only triggers once per discharge cycle
            notified=true
        fi
    fi

    # Reset the notified flag if the user plugs in the charger OR if charge goes above 20%
    if [ "$battery_state" = "charging" ] || [ "$battery_percentage" -gt 20 ]; then
        notified=false
    fi

    # Wait for 30 seconds before checking again
    sleep 30
done

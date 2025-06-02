#!/usr/bin/env bash

# Detect actual battery name (e.g., BAT0 or BAT1)
BATTERY=$(ls /sys/class/power_supply/ | grep BAT | head -n 1)
BATTERY_PATH="/sys/class/power_supply/$BATTERY"
AC_PATH="/sys/class/power_supply/ACAD"

# Default values
ac=0
battery_level=0
battery_max=0

# AC status
if [ -f "$AC_PATH/online" ]; then
    ac=$(cat "$AC_PATH/online")
fi

# Battery readings
if [ -f "$BATTERY_PATH/energy_now" ]; then
    battery_level=$(cat "$BATTERY_PATH/energy_now")
elif [ -f "$BATTERY_PATH/charge_now" ]; then
    battery_level=$(cat "$BATTERY_PATH/charge_now")
fi

if [ -f "$BATTERY_PATH/energy_full" ]; then
    battery_max=$(cat "$BATTERY_PATH/energy_full")
elif [ -f "$BATTERY_PATH/charge_full" ]; then
    battery_max=$(cat "$BATTERY_PATH/charge_full")
fi

# Prevent division by zero
if [ "$battery_max" -eq 0 ]; then
    echo "Battery info not available"
    exit 1
fi

# Compute battery percentage
battery_percent=$(( battery_level * 100 / battery_max ))

# Choose icon based on status
if [ "$ac" -eq 1 ]; then
    icon=""
    if [ "$battery_percent" -gt 97 ]; then
        echo "$icon"
    else
        echo "$icon $battery_percent %"
    fi
else
    if [ "$battery_percent" -gt 85 ]; then
        icon="#21"
    elif [ "$battery_percent" -gt 60 ]; then
        icon="#22"
    elif [ "$battery_percent" -gt 35 ]; then
        icon="#23"
    elif [ "$battery_percent" -gt 10 ]; then
        icon="#24"
    else
        icon="#25"
    fi
    echo "$icon $battery_percent %"
fi

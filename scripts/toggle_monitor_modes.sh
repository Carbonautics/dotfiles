#!/bin/bash

INTERNAL="eDP"
EXTERNAL="HDMI-A-0"

# Check if external monitor is connected
EXTERNAL_CONNECTED=$(xrandr | grep "$EXTERNAL connected")

# Check current status
INTERNAL_ON=$(xrandr --listmonitors | grep "$INTERNAL")
EXTERNAL_ON=$(xrandr --listmonitors | grep "$EXTERNAL")

if [[ -n "$EXTERNAL_CONNECTED" ]]; then
    if [[ -n "$EXTERNAL_ON" && -z "$INTERNAL_ON" ]]; then
        # External is on, internal is off -> switch to dual
        xrandr --output "$INTERNAL" --auto --primary \
               --output "$EXTERNAL" --mode 1920x1080 --rate 180 --right-of "$INTERNAL"
    elif [[ -n "$EXTERNAL_ON" && -n "$INTERNAL_ON" ]]; then
        # Both are on -> switch to internal only
        xrandr --output "$EXTERNAL" --off \
               --output "$INTERNAL" --auto --primary
    else
        # Either internal only or unknown -> switch to external only
        xrandr --output "$INTERNAL" --off \
               --output "$EXTERNAL" --mode 1920x1080 --rate 180 --primary
    fi
    ~/.config/polybar/launch.sh
else
    # External not connected -> fallback to internal
    xrandr --output "$EXTERNAL" --off \
           --output "$INTERNAL" --auto --primary

    ~/.config/polybar/launch.sh
    notify-send "Switched to Internal Only"
fi
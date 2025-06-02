#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 1; done

# Detect wireless interface only once
WIRELESS=$(ls /sys/class/net/ | grep '^wl' | head -n 1)

# Launch polybar for each monitor
for m in $(polybar --list-monitors | cut -d":" -f1); do
  MONITOR="$m" WIRELESS="$WIRELESS" polybar --reload &
done

echo "Bars launched..."


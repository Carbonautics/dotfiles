#!/bin/sh
#source https://github.com/x70b1/polybar-scripts

updates=$(apt list --upgradable 2> /dev/null | grep -c upgradable);

if [ "$updates" -gt 0 ]; then
    echo "# $updates"
else
    echo ""
fi
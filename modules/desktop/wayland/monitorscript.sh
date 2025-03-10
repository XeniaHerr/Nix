#!/usr/bin/env bash
#Stolen from https://gist.github.com/dr0bz/4f8bf8b8829506cf26d4e2acc770e5af
scriptname=$(basename "$0")
echo "$scriptname"
running_count=$(pgrep -f "$scriptname" | wc -l )
if [ "$running_count" -gt 2 ]; then
    echo "Exiting: Already running..."
    exit
fi


MONITOR_COUNT=

function handle {
    MONITOR_COUNT=$(hyprctl monitors | grep -c "Monitor")
    case $1 in 
	monitoraddedv2*)
	    echo "Currently $MONITOR_COUNT Monitors connected"
	    if [ "$MONITOR_COUNT" -ge 3 ]; then # Found 3 Monitors, must be the docking station
		echo "Disabling Monitor, found $MONITOR_COUNT"
		hyprctl keyword monitor eDP-1,disable
		sleep 1
		#hyprctl reload monitors
	    fi
	    ;;
	monitorremoved*)
	    if [ "$MONITOR_COUNT" -eq 0 ]; then
		echo "Currently 0 Monitors, enabling internal monitor"
		hyprctl keyword monitor e-DP1,preferred,auto,1
		sleep 4
		hyprctl reload monitors # This shouldn't be a problem
	    fi
	    ;;
	esac

    }


    socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do handle "$line"; done

#!/bin/bash

while true
do
	batterylevel=$(cat /sys/class/power_supply/BAT0/capacity)
	if [[ $(upower -i $(upower -e | grep 'BAT') | grep -E "state") == "    state:               charging" ]]
	then
		if [[ $batterylevel -gt 84 ]]
		then
			notify-send "Battery at "$batterylevel"%"
			if gnome-screensaver-command -q | grep "is active" # the screen is locked
			then
				while [[ $(upower -i $(upower -e | grep 'BAT') | grep -E "state") == "    state:               charging" ]]
				do
					spd-say -w "Battery charged. Unplug the computer."
					sleep 1
				done
				sleep 1
				spd-say -w "Thank you."
				if gnome-screensaver-command -q | grep "is active"
				then
					systemctl suspend
				fi
			fi
		fi
	else
		if [[ $batterylevel -lt 28 ]]
		then
			notify-send "Battery at "$batterylevel"%"
			if gnome-screensaver-command -q | grep "is active"
			then
				while [[ $(upower -i $(upower -e | grep 'BAT') | grep -E "state") == "    state:               discharging" ]]
	         	do
		            spd-say -w "Battery low. Plug in the computer."
	                sleep 1
	            done
	            sleep 1
	            spd-say "Thank you."
			fi
		fi
	fi
	sleep 60
done

#!/bin/bash

#sleeptime=60

while true
do
	batterylevel=$(cat /sys/class/power_supply/BAT0/capacity)
	if [[ $(upower -i $(upower -e | grep 'BAT') | grep -E "state") == "    state:               charging" ]]
	then
		#echo $batterylevel
		if [[ $batterylevel -gt 84 ]]
		then
			#echo "b"
			notify-send "Battery at "$batterylevel"%"
			if gnome-screensaver-command -q | grep "is active" # the screen is locked
			then
				#echo "c"
				while [[ $(upower -i $(upower -e | grep 'BAT') | grep -E "state") == "    state:               charging" ]]
				do
					#echo "d"
					#printf "\a" 
					#beep
					spd-say -w "Battery charged. Unplug the computer."
					sleep 1 #4
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
	                sleep 1 #4
	            done
	            sleep 1
	            spd-say "Thank you."
			fi
		fi
	fi
	sleep 60
done

: '
while [[ ( $(upower -i $(upower -e | grep 'BAT') | grep -E "state") == "state:               charging" ) && ( $(cat /sys/class/power_supply/BAT0/capacity) < 80 ) ]]
do
	sleep 1
	#cat /sys/class/power_supply/BAT0/capacity
done
beeps.sh
'

: <<'END_COMMENT'
This is a heredoc (<<) redirected to a NOP command (:).
The single quotes around END_COMMENT are important,
because it disables variable resolving and command resolving
within these lines.  Without the single-quotes around END_COMMENT,
the following two $() `` commands would get executed:
$(gibberish command)
`rm -fr mydir`
comment1
comment2 
comment3
END_COMMENT

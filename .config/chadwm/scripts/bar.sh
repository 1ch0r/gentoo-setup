#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/dracula


pad() {
  printf " ^c$black^%*s" 20 ""
}


cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)
  printf " ^c$blue^ $cpu_val"
  #printf "^c$blue^ ^b$black^ $cpu_val"
}

battery() {
  status="$(cat /sys/class/power_supply/BAT0/status)"
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  if [ "$status" == "Charging" ]; then
    printf "^c$green^ 󰂄 $get_capacity%%"
  else
    printf "^c$red^ 󱟤 $get_capacity%%"
  fi
}

brightness() {
  printf "^c$yellow^  "
  printf "^c$yellow^%.0f" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  printf "^c$blue^ "
  used=$(awk '/MemTotal|MemFree|Buffers|Cached/ {a[$1]=$2} 
    END {
      used=(a["MemTotal:"] - a["MemFree:"] - a["Buffers:"] - a["Cached:"])/1024;
      if (used > 1024)
        printf "%.1f GB", used/1024;
      else 
        printf "%.0f MB", used;
    }' /proc/meminfo)
  printf "^c$blue^ $used"
}


wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$white^ 󰤯^d^%s"" ^c$green^Connected" ;;
	down) printf "^c$white^ 󰤮^d^%s"" ^c$red^Disconnected" ;;
	esac
}


clock() {
	printf "^c$yellow^ 󱑎 "
	printf "^c$yellow^$(date '+%H:%M') "
}

while true; do

  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$(pad) $(battery) $(brightness) $(cpu) $(mem) $(wlan) $(clock)"
done

#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/dracula

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$blue^ ^b$black^ CPU"
  printf "^c$blue^ ^b$black^ $cpu_val"
}

pkg_updates() {
  #updates=$({ timeout 20 doas xbps-install -un 2>/dev/null || true; } | wc -l) # void
  updates=$({ timeout 20 checkupdates 2>/dev/null || true; } | wc -l) # arch
  # updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc -l)  # apt (ubuntu, debian etc)

  if [ -z "$updates" ]; then
    printf "  ^c$green^    Fully Updated"
  else
    printf "  ^c$green^    $updates"" updates"
  fi
}

battery() {
  status="$(cat /sys/class/power_supply/BAT0/status)"
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  if [[ "$status" == "Charging" ]]; then
    printf "^c$green^ 󰂄 $get_capacity%%"
  else
    printf "^c$red^ 󱟤 $get_capacity%%"
  fi
}

brightness() {
  printf "^c$yellow^   "
  printf "^c$yellow^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$white^ ^b$black^ 󰤨 ^d^%s" " ^c$green^Connected" ;;
	down) printf "^c$white^ ^b$black^ 󰤭 ^d^%s" " ^c$red^Disconnected" ;;
	esac
}

clock() {
	printf "^c$yellow^ ^b$black^ 󱑆 "
	printf "^c$yellow^^b$black^ $(date '+%H:%M')  "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$updates $(battery) $(brightness) $(cpu) $(mem) $(wlan) $(clock)"
done

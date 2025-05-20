#!/bin/sh

xrdb merge ~/.Xresources
xbacklight -set 10 &
feh --bg-fill /home/dev/Wallpapers/burl.png &
xset r rate 200 50 &
picom &
bash ~/.config/chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done

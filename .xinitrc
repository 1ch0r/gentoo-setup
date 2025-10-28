#!/bin/sh

picom --config ~/.config/picom/picom.conf &
exec ~/.config/chadwm/scripts/run.sh

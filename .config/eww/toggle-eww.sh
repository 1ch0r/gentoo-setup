#!/bin/sh

if ! pgrep -x "eww" > /dev/null; then
    eww daemon &
    sleep 0.5
fi

if eww active-windows | grep -q ": eww$"; then
    eww close eww
else
    eww open eww
fi

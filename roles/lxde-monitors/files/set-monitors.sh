#!/bin/sh

devices_n=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/" | wc -l)

if [ ${devices_n} -gt 1 ] ; then
    xrandr --output DP1   --mode 1920x1080 --pos 1680x-870 --rotate left \
           --output DP2-1 --mode 1920x1080 --pos 2760x-870 --rotate left \
           --output DP2-2 --mode 1680x1050 --pos 0x0       --rotate normal \
           --output eDP1  --off \
           --output DP2   --off \
           --output DP2-3 --off \
           --output HDMI1 --off \
           --output HDMI2 --off \
           --output VIRTUAL1 --off
else
    xrandr --output eDP1 --mode 1366x768 --pos 0x0 --rotate normal \
           --output DP1 --off --output DP2-1 --off --output DP2-2 --off \
           --output DP2 --off --output DP2-3 --off --output HDMI1 --off \
           --output HDMI2 --off --output VIRTUAL1 --off
fi


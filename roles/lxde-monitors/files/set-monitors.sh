#!/bin/sh

devices_n=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/" | wc -l)

if [ ${devices_n} -gt 1 ] ; then
    xrandr --output DP2-2    --auto \
           --output DP1      --auto --right-of DP2-2 \
           --output DP2-1    --auto --right-of DP1 \
           --output DP2      --auto \
           --output DP2-3    --auto \
           --output HDMI1    --auto \
           --output HDMI2    --auto \
           --output eDP1     --off  \
           --output VIRTUAL1 --off
else
    xrandr --output eDP1 --auto \
           --output DP1 --off --output DP2-1 --off --output DP2-2 --off \
           --output DP2 --off --output DP2-3 --off --output HDMI1 --off \
           --output HDMI2 --off --output VIRTUAL1 --off
fi


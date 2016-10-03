#!/bin/sh
xrandr --output DP1   --mode 1920x1080 --pos 1680x-870 --rotate left \
       --output DP2-1 --mode 1920x1080 --pos 2760x-870 --rotate left \
       --output DP2-2 --mode 1680x1050 --pos 0x0       --rotate normal \
       --output eDP1  --off
lxpanelctl restart


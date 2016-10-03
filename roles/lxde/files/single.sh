#!/bin/sh
xrandr --output eDP1 --mode 1366x768 --pos 0x0 --rotate normal --output DP1 --off --output DP2-1 --off --output DP2-2 --off
lxpanelctl restart


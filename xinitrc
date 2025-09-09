#!/bin/sh
export DISPLAY=:0
export XDG_CONFIG_HOME=/tmp
export XDG_DATA_HOME=/tmp
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


xset s off
xset -dpms
xset s noblank
xrandr --output DSI-1 --rotate inverted

exec supertuxkart


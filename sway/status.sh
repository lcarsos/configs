#!/bin/zsh

source ~/.zsh/functions/stardate

volume=$(ponymix is-muted && { echo "--" } || { ponymix get-volume })
battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | rg percentage | awk '{ print $2; }')
stardate=$(stardate)
timestamp=$(date +'%Y-%m-%d %H:%M')

echo "${volume} | ${battery} | $stardate | $timestamp"

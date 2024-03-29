#!/bin/bash

# stolen from:
# https://www.reddit.com/r/swaywm/comments/dvko6o/script_to_discover_active_displays_and_set_a/
#
# random_wallpaper
#
# Desc: This discovers the names of the active displays and sets
# a separate random wallpaper for each.
#
# Requirements
# swaywm and swaybg to set wallpaper
#

# Get outputs/displays from swaymsg
DISPLAYS=$(swaymsg --type get_outputs --raw | jq --raw-output '.[] |select(.active) | .name')

# Define directory for wallpapers and cache directory for current wallpapers
WALLPAPER_DIR="$HOME/m/i/startrek"
CACHE_DIR="$HOME/.cache/sway"

if [[ ! -d "$CACHE_DIR" ]]
then
	mkdir -p "$CACHE_DIR"
fi


killall swaybg # Kill swaybg before assigning wallpaper

# Cycle through outputs/displays
count=1
for OUTPUT in $DISPLAYS
do
    WALLPAPER=$CACHE_DIR/wallpaper$count.jpg # Set cached current wallpaper name

    # link random wallpaper to cached directory
    ln -fs $WALLPAPER_DIR/$(ls $WALLPAPER_DIR | shuf -n 1) $WALLPAPER 

    # assign cached wallpaper to correct display
    swaymsg exec "swaybg -o $OUTPUT -i $WALLPAPER -m fill"
    count=$((count + 1))
done

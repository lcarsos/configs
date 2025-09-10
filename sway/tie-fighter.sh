#!/usr/bin/env bash

if [[ $HOSTNAME == "jamesmonroe" ]]; then
    sway "output DP-3 transform 270 position -1800 0"
    sway "output DP-2 transform 0 position 0 0"
    sway "output DP-1 transform 90 position 3840 0"
elif [[ $HOSTNAME == "martinvanburen" ]]; then
    sway "output eDP-1 position 0 0"
    sway "output DP-6 transform 270 position 2560 0"
    sway "output DP-5 transform 0 position 4000 0"
    sway "output DP-1 transform 90 position 6560 0"

fi

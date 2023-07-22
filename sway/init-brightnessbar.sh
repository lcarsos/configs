#!/usr/bin/env zsh

mkfifo /tmp/brightnessbar
tail -f /tmp/brightnessbar | wob &

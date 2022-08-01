#!/usr/bin/env zsh

mkfifo /tmp/volumebar
tail -f /tmp/volumebar | wob &

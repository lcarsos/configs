#!/bin/zsh

source ~/.zsh/functions/stardate

japaneseDayOfWeek() {
    LANG=ja_JP.UTF-8 date +'%a'
}

calcBattery() {
    local bat_state=$(upower-i /org/freedesktop/UPower/devices/battery_BAT0 | rg 'state' | awk '{ print $2; }')
    local percentage=$(upower-i /org/freedesktop/UPower/devices/battery_BAT0 | rg 'percentage' | awk '{ print $2; }')
    if [[ ${bat_state} == charging ]]; then
        echo ${percentage}
    else
        local timer=$(upower-i /org/freedesktop/UPower/devices/battery_BAT0 | rg 'time to empty' | awk '{ print $4 " " $5; }')
        echo "${timer-nan} (${percentage})"
    fi
}

volume=$(ponymix is-muted && { echo "--" } || { ponymix get-volume })
battery=${calcBattery}
stardate=$(stardate)
timestamp=$(date +'%Y-%m-%d %H:%M')
dayOfWeek=$(japaneseDayOfWeek)

echo "${volume} | ${battery} | $stardate | (${dayOfWeek}) $timestamp"

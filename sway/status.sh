#!/bin/zsh

source ~/.zsh/functions/stardate

japaneseDayOfWeek() {
    LANG=ja_JP.UTF-8 date +'%a'
}

loadAvgs() {
    local load=($(tr ' ' '\n' < /proc/loadavg | head -n 3))
    echo ${load[1]}/${load[2]}/${load[3]}
}

calcBattery() {
    local bat_state=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | rg 'state' | awk '{ print $2; }')
    local percentage=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | rg 'percentage' | awk '{ print $2; }')
    if [[ ${bat_state} == charging ]]; then
        echo ${percentage}
    else
        local timer=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | rg 'time to empty' | awk '{ print $4 " " $5; }')
        echo "${timer-nan} (${percentage})"
    fi
}

ipAddr() {
    local addr=$(ip addr show dev wlp1s0 | grep -w inet | awk '{ print $2; }')
    if [ $addr -z ]; then
        echo "wifi down"
    else
        echo $addr
    fi
}

volume=$(ponymix is-muted && { echo "--" } || { ponymix get-volume })
battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | rg percentage | awk '{ print $2; }')
time_remaining=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | rg "time to" | cut -d':' -f 2 | sed 's/^ *//')
stardate=$(stardate)
timestamp=$(date +'%Y-%m-%d %H:%M')
dayOfWeek=$(japaneseDayOfWeek)
loadAvg=$(loadAvgs)
ip=$(ipAddr)

echo "${loadAvg} | ${volume} | ${ip} | ${time_remaining} (${battery}) | $stardate | (${dayOfWeek}) $timestamp"

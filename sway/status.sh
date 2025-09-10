#!/bin/zsh

source ~/.zsh/functions/stardate

japaneseDayOfWeek() {
    LANG=ja_JP.UTF-8 date +'%a'
}

loadAvgs() {
    local load=($(tr ' ' '\n' < /proc/loadavg | head -n 3))
    echo ${load[1]}/${load[2]}/${load[3]}
}

memUsage() {
    local vals=($(cat /proc/meminfo | head -n 5 | awk '{ print $2; }'))
    local total=${vals[1]}
    local free=${vals[2]}
    local cache=${vals[5]}
    local used=$(dc <<< "$total $free $cache + - p")
    local used_pct=$(dc <<< "1 k 100 $used * $total / p")
    local used_G=$(dc <<< "1 k $used 1024 1024 * / p")
    echo "${used_pct}% ${used_G}G"
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
    local devices=($(ip a | grep -E "^[0-9]+: (enp|wlp)" | awk '{ gsub(/:/, "", $2); print $2 }'))
    local addr=$(for dev in $devices; do ip addr show dev $dev | grep -w inet | awk '{ print $2; }'; done)
    if [[ $addr == "" ]]; then
        echo "wifi down"
    else
        echo $addr
    fi
}

volume=$(wpctl get-volume @DEFAULT_SINK@ | awk '{ print $2 }')
battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | rg percentage | awk '{ print $2; }')
time_remaining=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | rg "time to" | cut -d':' -f 2 | sed 's/^ *//')
stardate=$(stardate)
timestamp=$(date +'%Y-%m-%d %H:%M')
dayOfWeek=$(japaneseDayOfWeek)
loadAvg=$(loadAvgs)
ramUsed=$(memUsage)
ip=$(ipAddr)

echo "${loadAvg} | ${ramUsed} | ${volume} | ${ip} | ${time_remaining} (${battery}) | $stardate | (${dayOfWeek}) $timestamp"

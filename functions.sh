#!/bin/bash
source ~/control/scripts/style.sh
function ok {
    echo -e "[ $(styleGreen ok) ] $1"
}
function note {
    echo -e "[$(styleOrange notice)] $1"
}
function fail {
    echo -e "[$(styleRed fail)] $1"
}
# run external command via ssh and grab the output
# arg1 is the IP Address, the last byte
# arg2 is the command
function runexternal {
    ssh id@192.168.100.$1 "$2 > runexternal"
    rsync -avh id@192.168.100.$1:~/runexternal . &> /dev/null
    ssh id@192.168.100.$1 "rm runexternal"
}
function runexternalMAC {
    ssh id@192.168.100.$1 "$2 > runexternal"
    rsync -avh id@192.168.100.$1:~/runexternal . &> /dev/null
    ssh id@192.168.100.$1 "rm runexternal"
}
# send notification via telegram
function notifyTelegram {
    curl -s -X POST https://api.telegram.org/botxxx:xxx/sendMessage -d chat_id=xxx -d text="$1" > /dev/null
}

#!/bin/bash
#    written by Jacob Obrman in June 2021
#Output styling
Green='\033[0;32m'
Red='\033[0;31m'
Orange='\033[0;33m'
Yellow='\033[1;33m'
Cyan='\033[0;36m'
NC='\033[0m'
function okfail {
    if [ $1 = ok ]; then
	echo -e "[ ${Green}ok${NC} ] $2"
    else
	echo -e "[${Red}fail${NC}] $2"
    fi
}
function styleGreen {
    echo -e "${Green}$1${NC}"
}
function styleOrange {
    echo -e "${Orange}$1${NC}"
}
function styleRed {
    echo -e "${Red}$1${NC}"
}
function styleYellow {
    echo -e "${Yellow}$1${NC}"
}
function styleCyan {
    echo -e "${Cyan}$1${NC}"
}

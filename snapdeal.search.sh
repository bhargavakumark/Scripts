#!/bin/bash

. ~/.bashrc

function usage
{
    echo "$0"
    exit 1
}

function searchWoohoo()
{
    wget -O - https://www.snapdeal.com/product/woohoo-egift-card/641543859318 > /tmp/snapdeal.woohoo 2> /dev/null 
    cat /tmp/snapdeal.woohoo | grep  'has been sold out' > /dev/null && return
    cat /tmp/snapdeal.woohoo | grep -A1 genericOfferClass | grep -iE 'standard|hdfc|axis|sbi|icici' | grep -E '10%|15%'
    if [ $? -eq 0 ]; then
        date
	/root/node/node-v5.6.0-linux-x64/bin/node /root/scraper/notification.cmd.js custom 25722518 'Snapdeal woohoo' 'Snapdeal woohoo available at discount'
        exit 0
    fi
}

while :; do
    searchWoohoo
    sleep 60
done


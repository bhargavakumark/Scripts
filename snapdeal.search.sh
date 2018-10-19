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
    cat /tmp/snapdeal.woohoo | grep  'has been sold out' && return
    cat /tmp/snapdeal.woohoo | grep -A1 genericOfferClass | grep -iE 'standard|hdfc|axis|sbi|icici|rbl' | grep -E '10%|15%'
    if [ $? -eq 0 ]; then
        date
        alertmac "Found woohoo giftcards on snapdeal"
        exit 0
    fi
}

while :; do
    searchWoohoo
    sleep 60
done


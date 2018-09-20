#!/bin/bash

. ~/.bashrc

function usage
{
    echo "$0 <amazon/flipkart/freecharge-in> [discount]"
    exit 1
}

[ -z "$1" ] && usage

function searchAll()
{
    wget -q -O - http://www.zingoy.com/gift-cards/$1 > /tmp/$1
    if [ $? -eq 0 ]; then
        grep 'It seems there are no giftcards available' /tmp/$1 > /dev/null
        if [ $? -ne 0 ]; then
            alertmac "Found giftcards of $1"
            exit 0
        fi
    fi
    sleep 20
}

function searchDiscount()
{
    wget -q -O - http://www.zingoy.com/gift-cards/$1 > /tmp/$1
    if [ $? -eq 0 ]; then
        cat /tmp/$1 | grep icon-rupee | awk '{print $NF}' | awk -F'.' '{print $1}' |  sed 'N;s/\n/ /' |
        while read value price; do
            [ -z "$value" -o -z "$price" ] && continue
            let discount=value-price
            let perc=$discount*100/value
            if [ $perc -ge $2 ]; then
                alertmac "Found giftcards of $1 at discount $2"
                exit 0
            fi
        done
    fi
    sleep 20
}

while :; do
    if [ -z "$2" ]; then
        searchAll $1
    else
        searchDiscount $1 $2
    fi
done


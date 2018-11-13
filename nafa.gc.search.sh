#!/bin/bash

. ~/.bashrc

function usage
{
    echo "$0 <amazon/flipkart/freecharge-in> [discount]"
    exit 1
}

[ -z "$1" ] && usage

function searchDiscount()
{
    for i in {1..100}; do
        wget -O - https://www.nafa.in/buy-gift-cards/$1?page=$i 2> /dev/null | grep -E '<td class="right">&#8377;' | awk -F';' '{print $2}' | sed 's/<.*//g' | sed 'N;N;s/\n/ /g' | sed 's/,//g' > /tmp/nafa.$1
        lines=$(cat /tmp/nafa.$1 | wc -l)
        [ $lines -eq 0 ] && break
        while read mrp discount price; do
            let discountperc=discount*100/mrp
            echo $mrp $discount $price $discountperc
            [ $discountperc -gt $2 ] && echo "https://www.nafa.in/buy-gift-cards/$1?page=$i"
        done < /tmp/nafa.$1
    done
}

[ -z "$1" -o -z "$2" ] && usage
searchDiscount $1 $2


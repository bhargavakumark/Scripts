#!/bin/bash

function parseargs
{
    while ! [ -z "$1" ]; do
        case "$1" in 
        -image)
            image=$2
            shift
            ;;

        -host)
            host=$2
            shift
            ;;

        -physicalrdm)
            prdm=true
            ;;

        -bin)
            bin=$2
            shift
            ;;

        -job)
            job=$2
            shift
            ;;

        esac
        shift
    done

    return 0
}


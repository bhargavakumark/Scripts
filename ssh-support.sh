#!/bin/bash

. /home/bhargava/bin/ssh_askpass.sh

args="$*"

setPassword symantec
exec setsid ssh -n -l support $args


#!/bin/bash

. /home/bhargava/bin/ssh_askpass.sh

args="$*"

setPassword symantec
setsid ssh -l support $args


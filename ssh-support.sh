#!/bin/bash

. /home/bhargava/bin/ssh_askpass.sh

args="$*"

setPassword symantec
setsid ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l support $args


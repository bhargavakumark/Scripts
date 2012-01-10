#!/bin/bash

function setPassword
{
	local t_password="$1" 
	[ -z "$1" ] && return

	export DISPLAY=none:0.0
	export SSH_ASKPASS=/tmp/ssh_askpass.sh
	pipename="/tmp/ssh_pipe.$$.$$"

	echo "echo $t_password" > $SSH_ASKPASS
	chmod 700 ${SSH_ASKPASS}

	return 0
}


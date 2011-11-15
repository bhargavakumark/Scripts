#!/bin/bash

# function to acquire to flock on a local file
# Usage
#	flock [-e|-x|-w <timeout>] <file>
# Return
#	non-zero in case of errors
#	flock_fd variable will contain the fd
function flock
{
	[ -z "$1" ] && return 

	local file="" timeout=20 mode="-x"
	while ! [ -z "$1" ]; do
		case "$1" in
		-x)
			mode="-x"
			shift
			;;
		-s)
			mode="-s"
			shift
			;;
		-w)
			timeout=$2
			shift
			shift
			;;
		*)
			file=$1
			;;
		esac
		! [ -z "$file" ] && break
	done
	[ -z "$file" ] && return 1

	! [ -f "$file" ] && touch $file
	! [ -f "$file" ] && return 1

	local freefd=`ls /proc/$$/fd | sort -n | awk 'BEGIN{count=0} {if($1 != count) {print count; exit} else {count++}}'` 
	let freefd=$freefd+1

	eval "exec $freefd>>$file"
	[ $? -ne 0 ] && return 1
	flock $mode -w $timeout $freefd
	local ret=$?
	if [ $ret -eq 0 ]; then
		flock_fd=$freefd
	else
		eval "exec $freefd>&-"
	fi

	return $ret
}

# function to unlock a local flock
# Usage
#	flock_unlock <fd>
# Return
#	non-zero in case of errors
function flock_unlock
{
	# close the file, it would remove the locks
	[ -z "$1" ] && return 1
	eval "exec $1>&-"
	return 0
}


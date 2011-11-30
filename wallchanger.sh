#!/bin/bash
. /home/bhargava/nasgw/src/common/scripts/supportfn.sh

DEFAULT_INTERVAL=5

function usage
{
	echo "$0 -f <folder> -i <interval>"
	exit 1
}

interval=$DEFAULT_INTERVAL
files_list[0]=""

[ -z "$1" ] && usage
[ -z "$2" ] && usage

function add_dir
{
	[ -z "$1" ] && return 1
	find $1 -name '*.jpg' > /tmp/a 
	while read i; do 
		files_list[$files_list_index]=$i
		files_list_index=`expr $files_list_index + 1`
	done < /tmp/a
	rm /tmp/a
}

files_list_index=0

while ! [ -z "$1" ] ; do
	option=$1
	arg=$2

	case $option in 
	"-f" )
		if ! [ -d $2 ]; then
			echo "folder $2 does not exist"
			usage
		fi
		add_dir "$2"
		;;
	"-i" )
		if [ -z "$arg" ] ; then
			echo "argument required for -i"
			usage
		fi
		interval=$arg
		;;
	*)
		echo "unknown option $option"
		usage
	esac
	shift
	shift
done

while :; do
	index=`expr $RANDOM % $files_list_index`
	! [ -f "${files_list[$index]}" ] && continue
	gsettings set org.gnome.desktop.background picture-uri "file://${files_list[$index]}"
#	gconftool-2 -s /desktop/gnome/background/picture_filename -t string "${files_list[$index]}"
	mv /tmp/currentwall /tmp/currentwall.old
	echo "${files_list[$index]}" > /tmp/currentwall
	sleep $interval
done





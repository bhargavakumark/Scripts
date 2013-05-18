#!/bin/bash

dir=$(dirname $0)
. $dir/includes.sh
. $dir/engine.ops.sh

set -x
image=Image_0005462
host=sles11sp2-01
prdm=false
bin=~/bhargava/udpengine.bhargava.01
job=Job_bhargava
app=
slt=
slp=
policy=
deletejobhistory=0
delete=0
help=0

function Usage
{
    echo "Default for -bin is ~/bhargava/udpengine.bhargava.01"
    echo "Default for -job is Job_bhargava"
    echo "$0 deleteimage -image <image> [-bin <binary-to-use>] [-job <job-name>]"
    echo "$0 unmountimage -image <image> [-delete] [-bin <binary-to-use>] [-job <job-name>]"
    echo "$0 mountimage -image <image> -host <host> [-physicalrdm] [-bin <binary-to-use>] [-job <job-name>]"
    echo "$0 expireimages -app <appid/appname> [-bin <binary-to-use>] [-job <job-name>]"
    echo "$0 expiremounts -app <appid/appname> [-bin <binary-to-use>] [-job <job-name>]"
    echo "$0 deletejobhistory -job <job-name>"
    echo "$0 snap -app <appid/appname> [-policy <policyid>] [-job <job-name>] [-bin <binary-to-use>]"
    echo "$0 protect -app <appid/appname> [-slt <sltname|id>] [-slp <slpname|id>]"
    echo "$0 unprotect -app <appid/appname>"
}

cmd=$1
shift
if [ -z "$cmd" ]; then
    Usage $*
    exit 1
fi

parseargs $*

if [ $help -eq 1 -o "$cmd" == "-h" ]; then
    Usage $*
    exit 0
fi

/act/postgresql/bin/psql actdb act -c "delete from jobdata where jobname='$job'"
#udsinfo lsbackup | grep Image_bhargava

case $cmd in 
mountimage)
    mountimage $image; ret=$?
    ;;

unmountimage)
    unmountimage $image ; ret=$?
    [ $ret -ne 0 ] && break
    if [ $delete -eq 1 ]; then
        deleteimage $image ; ret=$?
    fi
    ;;

deleteimage)
    deleteimage $image ; ret=$?
    ;;

expiremounts)
    if [ -z "$app" ]; then
        echo "-app <appid/appname> not specified"
        exit 1
    fi
    expiremounts
    ;;

expireimages)
    if [ -z "$app" ]; then
        echo "-app <appid/appname> not specified"
        exit 1
    fi
    expireimages
    ;;

protect)
    if [ -z "$app" ]; then
        echo "-app <appid/appname> not specified"
        exit 1
    fi
    protect 
    ;;

unprotect)
    if [ -z "$app" ]; then
        echo "-app <appid/appname> not specified"
        exit 1
    fi
    unprotect 
    ;;

deletejobhistory)
    jobHistoryDelete $job
    ;;

snap)
    snapjob $job
    ;;

*)
    echo Inavlid command : $cmd
    Usage $*
    exit 1
    ;;
esac

exit $ret


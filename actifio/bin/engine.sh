#!/bin/bash

dir=$(dirname $0)
. $dir/includes.sh
. $dir/engine.ops.sh

set -x
image=Image_0005462
host=sles11sp2-01
prdm=false
bin=/act/bin/udprestore.bhargava.01
job=Job_bhargava

function Usage
{
    echo "TODO"
}

cmd=$1
shift
if [ -z "$1" ]; then
    Usage
    exit 1
fi

parseargs $*

/act/postgresql/bin/psql actdb act -c "delete from jobdata where jobname='$job'"

#udsinfo lsbackup | grep Image_bhargava

case $cmd in 
mountimage)
    mountimage ; ret=$?
    ;;

unmountimage)
    unmountimage ; ret=$?
    ;;

*)
    echo Inavlid command : $cmd
    Usage
    exit 1
    ;;
esac

exit $ret

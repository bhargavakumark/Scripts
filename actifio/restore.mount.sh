#!/bin/bash

set -x
image=Image_0005462

host=sles11sp2-01

mntpt=lvmtestcg1

job=Job_bhargava

/act/postgresql/bin/psql actdb act -c "delete from jobdata where jobname='$job'"

#udsinfo lsbackup | grep Image_bhargava

while :; do
    echo "<run jobname=\"$job\" jobtype=\"restore\"/>"
    echo
    echo "<mount backupname=\"$image\" host=\"$host\"/>"
    echo
    break
done | /act/bin/udprestore.bhargava.01
    
while :; do
    echo "<run jobname=\"$job\" jobtype=\"restore\"/>"
    echo
    echo "<mount backupname=\"$image\" host=\"$host\"/>"
    echo
    break
done | /act/bin/udprestore.bhargava.01
    

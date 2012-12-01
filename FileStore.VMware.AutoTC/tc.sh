#!/bin/bash

set -x
ssh="ssh -n"

TC_SCRIPTS_DIR=/mnt/sdd1/tc
rm -f /home/tcuser/.ssh/authorized_keys
rm -f /home/tcuser/.ssh/known_hosts

console_ip="192.168.30.201"

$TC_SCRIPTS_DIR/enable_support.pl $console_ip
$TC_SCRIPTS_DIR/change_root_passwd.pl $console_ip root123
$TC_SCRIPTS_DIR/ssh-key-exchange.pl $console_ip root123

# cleanup volumes on the openfiler
openfiler_vols="/dev/mapper/dg1-vol1 /dev/mapper/dg1-vol2 /dev/mapper/dg1-vol3"
openfiler_host="10.209.105.225"

$TC_SCRIPTS_DIR/add_to_known_hosts.pl $openfiler_host 
for vol in $openfiler_vols; do
	$ssh root@$openfiler_host dd if=/dev/zero of=$vol
done

time_to_wait=10800
start_date=`date "+%s"`
let end_date=$start_date+$time_to_wait
while :; do
	$ssh root@$console_ip "/opt/VRTSnasgw/scripts/clusterconfig.sh show | grep INSTALLED"
	if [ $? -eq 0 ]; then
		echo "2nd node install successful"
		break
	fi
	cur_date=`date "+%s"`
	if [ $cur_date -gt $end_date ]; then
		echo "Waited for $time_to_wait"
		exit 1	
	fi	
	sleep 30
done

sleep 10
ip=`$ssh root@$console_ip "/opt/VRTSnasgw/scripts/clusterconfig.sh show | awk '/INSTALLED/ {print \\$4}' | sed -e 's/(//g' -e 's/)//g'"`
if [ -z "$ip" ]; then
	echo "ip could not be found from cluster show"
	exit 1
fi

$ssh root@$console_ip /opt/VRTSnasgw/scripts/clusterconfig.sh add $ip | grep ERROR
if [ $? -eq 0 ]; then
	echo "ERROR while adding $ip to cluster"
	exit 1
fi
#exit 0


TC_VM1_NAME="autotc_01"
TC_VM2_NAME="autotc_02"
tc_vm1_name=$TC_VM1_NAME
tc_vm2_name=$TC_VM2_NAME
tc_vm1_vmx_path=$VM_CLONE_DIR/$TC_VM1_NAME/$TC_VM1_NAME.vmx
tc_vm2_vmx_path=$VM_CLONE_DIR/$TC_VM2_NAME/$TC_VM2_NAME.vmx
tc_vm1_pip=`$ssh root@$console_ip /opt/VRTSnasgw/scripts/ipconfig.sh show  | grep Physical | grep pubeth0 | grep $tc_vm1_name | awk '{print $1}'`
tc_vm2_pip=`$ssh root@$console_ip /opt/VRTSnasgw/scripts/ipconfig.sh show  | grep Physical | grep pubeth0 | grep $tc_vm2_name | awk '{print $1}'`

grep -vE "$tc_vm1_name|$tc_vm2_name" /etc/hosts > /tmp/hosts.$$
echo "$tc_vm1_pip		$tc_vm1_name" >> /tmp/hosts.$$
echo "$tc_vm2_pip		$tc_vm2_name" >> /tmp/hosts.$$
sudo cp /tmp/hosts.$$ /etc/hosts
rm /tmp/hosts.$$

$TC_SCRIPTS_DIR/add_to_known_hosts.pl $tc_vm1_name
$TC_SCRIPTS_DIR/add_to_known_hosts.pl $tc_vm2_name
$TC_SCRIPTS_DIR/add_to_known_hosts.pl $tc_vm1_pip
$TC_SCRIPTS_DIR/add_to_known_hosts.pl $tc_vm2_pip

grep -vE "$tc_vm1_name|$tc_vm2_name" /etc/nodeconf > /tmp/nodeconf.$$
echo "$tc_vm1_name::host::Linux::root::::ssh::SCP" >> /tmp/nodeconf.$$
echo "$tc_vm2_name::host::Linux::root::::ssh::SCP" >> /tmp/nodeconf.$$
sudo cp /tmp/nodeconf.$$ /etc/nodeconf
rm /tmp/nodeconf.$$

. /mnt/sdd1/tc/env.sh

tc_iscsi_tc_list="common_splited_tcs/storage/iscsi.tc common_splited_tcs/storage/iscsi_discovery.tc common_splited_tcs/storage/iscsi_target.tc common_splited_tcs/storage/iscsi_device.tc"

tc_passed=""
tc_failed=""
tc_notrun=""
tc_indet=""
tc_oldpwd=`pwd`
cd $TC_DIR
for tc_test in $tc_iscsi_tc_list;do
	cd `dirname $tc_test`
	$TC_DIR/bin/trun -vf `basename $tc_test` | tee /tmp/tc.log
	grep 'Tests Passed' /tmp/tc.log | sed 's/ //g' | grep 'TestsPassed:1' && tc_passed="$tc_passed `basename $tc_test`"
	grep 'Tests Failed' /tmp/tc.log | sed 's/ //g' | grep 'TestsFailed:1' && tc_failed="$tc_failed `basename $tc_test`"
	grep 'Tests Not Run' /tmp/tc.log | sed 's/ //g' | grep 'TestsNotRun:1' && tc_notrun="$tc_notrun `basename $tc_test`"
	grep 'Tests Indet' /tmp/tc.log | sed 's/ //g' | grep 'TestsIndet:1' && tc_indet="$tc_indet `basename $tc_test`"
	cd -
done	

tc_iscsi_device="pubeth0"
tc_iscsi_host="192.168.30.2:3260"

for i in `$ssh root@$tc_vm1_name /opt/VRTSnasgw/scripts/iscsiinitconfig.sh discovery list | awk 'NR>3'`; do
	$ssh root@$tc_vm1_name "/opt/VRTSnasgw/scripts/iscsiinitconfig.sh discovery del $i" 
done
for i in `$ssh root@$tc_vm1_name /opt/VRTSnasgw/scripts/iscsiinitconfig.sh target list | awk 'NR>3' | awk '{print $1}'`; do
	$ssh root@$tc_vm1_name "/opt/VRTSnasgw/scripts/iscsiinitconfig.sh target del $i" 
done

$ssh root@$tc_vm1_name "/opt/VRTSnasgw/scripts/iscsiinitconfig.sh device add $tc_iscsi_device
			/opt/VRTSnasgw/scripts/iscsiinitconfig.sh start
			/opt/VRTSnasgw/scripts/iscsiinitconfig.sh discovery add $tc_iscsi_host"
sleep 2
#exit 0
tc_pool_name="pool_iscsi"
disk_list=`$ssh root@$tc_vm1_name /opt/VRTSnasgw/scripts/iscsiinitconfig.sh target list | grep $tc_iscsi_host | sed 's/ \+/ /g' | cut -d' ' -f4-`
disk_list=`echo $disk_list | sed 's/ /,/g'`
if [ -z "$disk_list" ]; then
	echo "Disk list failed"
	exit 1
fi
$ssh root@$tc_vm1_name /opt/VRTSnasgw/scripts/pool.sh create $tc_pool_name $disk_list

tc_fs_list="ndmp_fs1 ndmp_fs2 ndmp_fs3 ndmp_fs4 general_fs1"
for fs in $tc_fs_list; do
	$ssh root@$tc_vm1_name /opt/VRTSnasgw/scripts/fs.sh create simple fs $fs 50M $tc_pool_name
	$ssh root@$tc_vm1_name /opt/VRTSnasgw/scripts/fs.sh create simple tier $fs 50M $tc_pool_name
done

tc_list="common_splited_tcs/ftp/ftp_set.tc common_splited_tcs/ftp/ftp_server.tc common_splited_tcs/ftp/ftp_session.tc common_splited_tcs/ftp/ftp_local.tc common_splited_tcs/http/http_server.tc common_splited_tcs/http/http_session.tc common_splited_tcs/http/http_documentroot.tc common_splited_tcs/http/http_set.tc common_splited_tcs/http/http_alias.tc"
for tc_test in $tc_list;do
	cd `dirname $tc_test`
	$TC_DIR/bin/trun -vf `basename $tc_test` | tee /tmp/tc.log
	grep 'Tests Passed' /tmp/tc.log | sed 's/ //g' | grep 'TestsPassed:1' && tc_passed="$tc_passed `basename $tc_test`"
	grep 'Tests Failed' /tmp/tc.log | sed 's/ //g' | grep 'TestsFailed:1' && tc_failed="$tc_failed `basename $tc_test`"
	grep 'Tests Not Run' /tmp/tc.log | sed 's/ //g' | grep 'TestsNotRun:1' && tc_notrun="$tc_notrun `basename $tc_test`"
	grep 'Tests Indet' /tmp/tc.log | sed 's/ //g' | grep 'TestsIndet:1' && tc_indet="$tc_indet `basename $tc_test`"
	cd -
done

tc_backup_ip="192.168.30.253"
$ssh root@$tc_vm1_name /opt/VRTSnasgw/scripts/backup.sh -vip $tc_backup_ip any
$ssh root@$tc_vm1_name /opt/VRTSnasgw/scripts/backup.sh -start

sudo killall -9 ndmpd
nohup /root/ndmp_tape/src/linux/common/ndmp/server/ndmpd -f > /tmp/ndmp_tape.log 2>&1 &

tc_status_file=$TC_SCRIPTS_DIR/tc_status/`date "+%Y.%m.%d"`
touch $tc_status_file
for i in $tc_passed; do
	echo "`basename $i` 		PASSED" 	>> $tc_status_file
done
for i in $tc_failed; do
	echo "`basename $i` 		FAILED"		>> $tc_status_file
done
for i in $tc_notrun; do
	echo "`basename $i` 		NOT RUN"	>> $tc_status_file
done
for i in $tc_indet; do
	echo "`basename $i` 		INDETERMINATE"	>> $tc_status_file
done

mail -s "TC results for `date \"+%Y.%m.%d\"`" bhargava_kancharla@symatnec.com < $tc_status_file

exit 0

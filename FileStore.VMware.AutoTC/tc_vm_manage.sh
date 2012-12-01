#!/bin/bash

. /mnt/sdd1/tc/tc_vm_lib.sh

#Usage
#	vm_get_id <vmid>
VM_TEMPLATE_DIR="/mnt/sdd1/tc/tc.vm.machines.template"
VM_TEMPLATE_NAME="tc_template"
VM_CLONE_DIR="/mnt/sdd1/tc/testrun"

function tc_vm_create
{
	local vmname="$1"

	local template_dir="$VM_TEMPLATE_DIR"
	local template_name="$VM_TEMPLATE_NAME"
	local clone_dir="$VM_CLONE_DIR"

	vm_clone $template_dir $template_name $clone_dir $vmname

	vm_register $clone_dir/$vmname/$vmname.vmx

	return $?
}

function tc_ping_timeout
{
	if [ -z "$1" ]; then
		echo "Host not specified"
		return 1
	fi

	local ping_interval=10
	ping -i $ping_interval -c 5 -q $1
	[ $? -eq 0 ] && return 0

	return 1
}

TC_VM1_NAME="autotc_01"
TC_VM2_NAME="autotc_02"

function tc_cmd_retry
{
	local t_cmd="$1" t_retry_limit="$2" t_retry_count=0


	while :; do
		[ $t_retry_limit -eq $t_retry_count ] && return 1
		$1
		[ $? -eq 0 ] && return 0
		let t_retry_count=$t_retry_count+1
		sleep 5
	done
}

set -x

tc_vm1_name=$TC_VM1_NAME
tc_vm2_name=$TC_VM2_NAME
tc_vm1_vmx_path=$VM_CLONE_DIR/$TC_VM1_NAME/$TC_VM1_NAME.vmx
tc_vm2_vmx_path=$VM_CLONE_DIR/$TC_VM2_NAME/$TC_VM2_NAME.vmx
tc_cmd_retry "tc_vm_cleanup $tc_vm1_vmx_path" 5
if  [ $? -ne 0 ]; then
	echo "tc_vm_cleanup $tc_vm1_vmx_path failed"
	exit 1
fi
tc_cmd_retry "tc_vm_cleanup $tc_vm2_vmx_path" 5
if  [ $? -ne 0 ]; then
	echo "tc_vm_cleanup $tc_vm2_vmx_path failed"
	exit 1
fi
tc_cmd_retry "tc_vm_create $tc_vm1_name" 5
if  [ $? -ne 0 ]; then
	echo "tc_vm_create $tc_vm1_name failed"
	exit 1
fi
tc_cmd_retry "tc_vm_create $tc_vm2_name" 5
if  [ $? -ne 0 ]; then
	echo "tc_vm_create $tc_vm2_name failed"
	exit 1
fi
vm_get_id $tc_vm1_vmx_path; tc_vm1_vmid=$g_vmid
vm_get_id $tc_vm2_vmx_path; tc_vm2_vmid=$g_vmid

if [ -z "$tc_vm1_vmid" ] || [ -z "$tc_vm2_vmid" ]; then
	echo "Could not get vmid tc_vm1_vmid=$tc_vm1_vmid tc_vm2_vmid=$tc_vm2_vmid"
	exit 1
fi

image_path=/mnt/sdd1/vmware/image.iso
vm_ide_iso_image $tc_vm1_vmx_path $image_path
vm_reload $tc_vm1_vmid
vm_power_on $tc_vm1_vmid
#exit 0

console_ip="192.168.30.201"
date

time_to_wait=10800
start_date=`date "+%s"`
let end_date=$start_date+$time_to_wait
while :; do
	tc_ping_timeout $console_ip
	if [ $? -eq 0 ]; then
		echo "ping success"
		break
	fi
	cur_date=`date "+%s"`
	if [ $cur_date -gt $end_date ]; then
		echo "Waited for $time_to_wait"
		exit 1	
	fi	
done

# sleep for 30 min for master account to be enabled, and system to be rebooted
echo "sleeping for remaining install and system reboot"
sleep 3600 

vm_power_on $tc_vm2_vmid

exit 0

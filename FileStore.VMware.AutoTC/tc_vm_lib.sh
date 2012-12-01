#!/bin/bash

HOST=10.209.106.15
PORT=8332
VMWARE_VIM_CMD=vmware-vim-cmd
USERNAME=root
PASSWORD=root123

function vm_get_id
{
	local vmname=""

	if echo $1 | grep '^/'; then
		vmname="$1"
	else
		vmname="$1/"
	fi

	g_vmid=`$VMWARE_VIM_CMD -H $HOST  -O $PORT -U $USERNAME -P $PASSWORD vmsvc/getallvms 2> /dev/null | grep "$vmname" | awk '{print $1}'`
}	

#Usage
#	vm_power_on <vmid>
function vm_power_on
{
	$VMWARE_VIM_CMD -H $HOST  -O $PORT -U $USERNAME -P $PASSWORD vmsvc/power.on $1
	return $?
}

#Usage
#	vm_reload <vmid>
function vm_reload
{
	$VMWARE_VIM_CMD -H $HOST  -O $PORT -U $USERNAME -P $PASSWORD vmsvc/reload $1
	return $?
}

#Usage
#	vm_power_off <vmid>
function vm_power_off
{
	$VMWARE_VIM_CMD -H $HOST  -O $PORT -U $USERNAME -P $PASSWORD vmsvc/power.off $1
	return $?
}

#Usage
#	vm_power_reset <vmid>
function vm_power_reset
{
	$VMWARE_VIM_CMD -H $HOST  -O $PORT -U $USERNAME -P $PASSWORD vmsvc/power.reset $1
	return $?
}

#Usage
#	vm_unregister_vmid <vmid>
function vm_unregister_vmid
{
	$VMWARE_VIM_CMD -H $HOST  -O $PORT -U $USERNAME -P $PASSWORD vmsvc/unregister $1
	return $?
}

#Usage
#	vm_unregister_vmname <vmname>
function vm_unregister_vmname
{
	local vmid=""
	vm_get_id $1; vmid=$g_vmid
	if [ -z "$vmid" ]; then
		echo "VM with name/path $1 does not exist"
		return 1
	fi
	$VMWARE_VIM_CMD -H $HOST  -O $PORT -U $USERNAME -P $PASSWORD vmsvc/unregister $vmid
	return $?
}

#Usage
#	vm_register <FS absolute path of vmx file>
function vm_register
{
	$VMWARE_VIM_CMD -H $HOST  -O $PORT -U $USERNAME -P $PASSWORD solo/registervm $1
	return $?
}

#Usage
#	vm_clone <base directory> <template-name> <clone base-dir> <clone-name>
function vm_clone
{
	local template_dir="$1"
	local template_name="$2"
	local clone_dir="$3"
	local clone_name="$4"

	if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
		echo "incorrect usage vm_clone $@"
		return 1
	fi

	if ! [ -d $template_dir ]; then
		echo "$template_dir does not exist"
		return 1
	fi

	if ! [ -d "$template_dir" ]; then
		echo "$template_dir/$template_name does not exist"
		return 1
	fi

	if ! [ -d "$clone_dir" ]; then
		echo "$clone_dir does not exist"
		return 1
	fi

	if [ -d "$clone_dir/$clone_name" ]; then
		echo "$clone_dir/$clone_name exists"
		return 1
	fi

	cp -r $template_dir/$template_name $clone_dir/$clone_name
	cd $clone_dir/$clone_name
	rename $template_name $clone_name *
	sed -i "s/$template_name/$clone_name/g" *
	sed -i "s/^uuid.location = \(.*\)/uuid.location = \"\"/g" *vmx
	sed -i "s/^uuid.bios = \(.*\)/uuid.bios = \"\"/g" *vmx
	sed -i "s/^vc.uuid = \(.*\)/vc.uuid = \"\"/g" *vmx
	cd -

	return 0
}

function vm_ide_cdrom_vmxfile
{
	if ! [ -f "$1" ]; then
		echo "vmx file $1 does not exist"
		return 1
	fi
	sed -i "s/ide1:0.fileName\(.*\)/ide1:0.fileName = \"\/dev\/scd0\"/g" $1
	sed -i "s/ide1:0.deviceType\(.*\)/ide1:0.deviceType = \"atapi-cdrom\"/g" $1

	return 0
}

function vm_ide_iso_image
{
	if ! [ -f "$1" ]; then
		echo "vmx file $1 does not exist"
		return 1
	fi
	if [ -z "$2" ]; then
		echo "iso image path not provided"
		return 1
	fi
	sed -i "s;ide1:0.fileName\(.*\);ide1:0.fileName = \"$2\";g" $1
	sed -i "s/ide1:0.deviceType\(.*\)/ide1:0.deviceType = \"cdrom-image\"/g" $1

	return 0
}

function tc_vm_cleanup
{
	local vmpath="$1"

	if ! [ -f "$vmpath" ]; then
		echo "$vmpath does not exist"
	else	
		vm_get_id $vmpath; vmid=$g_vmid
		if [ -z "$vmid" ]; then
			echo "$vmid could not be found for $vmpath"
			return 0
		else	
			vm_power_off $vmid
			vm_unregister_vmid $vmid
			[ $? -ne 0 ] && return 1
		fi
		sleep 3
	fi
	local vmbase_dir=`dirname $vmpath`
	rm -rf $vmbase_dir

	return $?
}


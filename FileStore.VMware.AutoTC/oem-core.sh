#!/bin/bash

function usage
{
	echo "Usage: $0"
	echo "		[-logodir <logo-images-directory>]"
	echo "		[-product_vendor <product_vendor>]"
	echo "		[-product_name <product_name>]"
	echo "		[-product_name_short <product_short_name]"
	echo "		[-banner_file <banner_file_path>]"
	echo "		[-bootlogo_file <bootlogo_file_path>]"
	echo "		[-version_mapfile <version_map_file_path>]"
	echo "		[-do_gui_changes]"
	echo "		[-plugin_file <plguin_xml_file_path>]"
	echo "		[-product_change_mib <mib file name>]"
	echo "		<old_iso_path> <new_iso_path>"

	exit 1
}

function cleanup
{
	umount $MOUNT_PATH
	rm -rf $MOUNT_PATH
	rm -rf $MOUNT_PATH_NEW
	rm -rf /tmp/oem_mount_tmp.$$ >/dev/null 2>&1
}

while :; do
	if [ -z "$1" ]; then
		echo "ISO image file path not provided"
		usage
	fi

	case $1 in 
		-logodir) # Directory which contains the logo image files 
			# logo directory should contain images of all 
			# resolution sizes in jpg format and in spl format
			LogoModify=1
			LogoDir=$2
			if [ -z "$LogoDir" ]; then
				echo "Logo directory argument required for -logodir"
				usage
			fi
			if ! [ -d "$LogoDir" ]; then
				echo "$LogoDir is not directory" 
				usage
			fi
			shift; shift
			;;

		-product_vendor) # Vendor name of the product
			ProductVendorModify=1
			ProductVendor=$2
			if [ -z "$ProductVendor" ]; then
				echo "Product vendor argument required for -product_vendor"
				usage
			fi
			shift; shift
			;;

                -product_password_disable) # Disable defualt password change
                        DISABLE_PASSWD_CHANGE_PROMPT=1
                        shift
                        ;;

		-product_name) # Product full name used in man pages 
			       # header/footer
			ProductNameModify=1
			ProductName=$2
			if [ -z "$ProductName" ]; then
				echo "Product name argument required for -product_name"
				usage
			fi
			shift; shift
			;;

		-product_change_mib) # Change mib
			CHANGE_MIB=1
			MIB_FILE=$2
			if ! [ -f "$MIB_FILE" ]; then
                echo "Mib file name argument required for -product_change_mib"
                usage
            fi		
			shift; shift
			;;
		-product_name_short) # Shortform/abbrevation of product name 
				     # used in sfsgettxt
			ProductNameShortModify=1
			ProductNameShort=$2
			if [ -z "$ProductNameShort" ]; then
				echo "Product short name argument required for -product_name_short"
				usage
			fi
			shift; shift
			;;

		-banner_file) # path of the banner file
			BannerModify=1
			BannerPath=$2
			if ! [ -f "$BannerPath" ]; then
				echo "banner file path argument required for -banner_file"
				usage
			fi
			shift; shift
			;;
	
		-bootlogo_file) # path of the bootlogo file
                        BootlogoModify=1
                        BootlogoPath=$2
                        if ! [ -f "$BootlogoPath" ]; then
                                echo "bootlogo file path argument required for -bootlogo_file"
                                usage
                        fi
                        shift; shift
                        ;;
		-version_mapfile) # path of the version map file 
			VersionModify=1
			VersionMapFilePath=$2
			if [ -z "$VersionMapFilePath" ]; then
				echo "Version map file argument required for -version_mapfile"
				usage
			fi
			if ! [ -f "$VersionMapFilePath" ]; then
				echo "$VersionMapFilePath is not a file"
				usage
			fi
			shift; shift
			;;
			
		-do_gui_changes)
			GUIModify=1
			GUIDir="${LogoDir}/gui"
			if ! [ -d "$GUIDir" ]; then
				echo "Error: $GUIDir is not directory" 
				usage
			fi
			shift;
			;;
		-disable_gui_url)
			GUI_URL_DISABLE=1
			shift
			;;
		-plugin_file) # path of the plugin xml file
			PluginModify=1
			PluginFilePath=$2
			if [ -z "$PluginFilePath" ]; then
				echo "Plugin xml file argument required for -plugin_file"
				usage
			fi
			if ! [ -f "$PluginFilePath" ]; then
				echo "$PluginFilePath is not a file"
				usage
			fi
			shift; shift
			;;
		-default-install)
			DefaultInstall=1
			InstallConf=$2
			if [ -z "$InstallConf" ]; then
				echo "Install conf file argument required for -default-install"
				usage
			fi
			if ! [ -f "$InstallConf" ]; then
				echo "$InstallConf is not a file"
				usage
			fi
			. $InstallConf
			shift; shift
			;;
		-disable_license_info)
			License_Disable=1
			shift
			;;

		*) # ISO image file
			ImagePath=$1
			if ! [ -e $1 ]; then
				echo "ISO image file $ImagePath does not exist"
				usage
			fi
			file -b "$ImagePath" | grep 'ISO' > /dev/null
			if [ $? -ne 0 ]; then
				echo "$ImagePath not a ISO file"
				usage
			fi
			NewImagePath=$2
			if [ -z "$NewImagePath" ]; then
				echo "New file name not specified"
				usage
			fi
			break
			;;
	esac
done

MKISOFS=`which mkisofs`
MKFS=/sbin/mkfs
OEM_CONF_FILE="oem.conf"
MAN_DIR="symc/nasg/man/man1"

MOUNT_PATH="/tmp/oem_mount.$$"
MOUNT_PATH_NEW="/tmp/oem_mount_new.$$"

OLD_PRODUCT_NAME="Symantec FileStore"
OLD_PRODUCT_NAME_SHORT="SFS"
PRODUCT_NAME_LIST="./symc/nasg/YaST2/clients/inst_sfs_post_install.ycp"
PRODUCT_NAME_SHORT_LIST="./symc/nasg/YaST2/clients/inst_sfs_post_install.ycp ./control_join.xml ./control.xml"
PRODUCT_NAME_TO_SHORT_NAME_LIST="./symc/nasg/scripts/smbglobal.conf"
ADD_PLUGIN_TOOL="./add_plugin_hook.pl"

# Mount the iso on a temporary path
base_dir=`dirname $ImagePath`
filename=`basename $ImagePath`
iso_location_fstype=`/bin/df -PT $ImagePath|tail -1|awk '{print $2}'`
if [ "X$iso_location_fstype" = "Xvxfs" ]; then
        mkdir -p /tmp/oem_mount_tmp.$$
        cp $ImagePath /tmp/oem_mount_tmp.$$/
        ImagePath="/tmp/oem_mount_tmp.$$/$filename"
fi

echo "Mounting iso : $ImagePath to $MOUNT_PATH"
mkdir -p $MOUNT_PATH
mkdir -p $MOUNT_PATH_NEW
mount -o loop $ImagePath $MOUNT_PATH
if [ $? -ne 0 ]; then
	echo "could not mount $ImagePath"
	cleanup
fi


BOOT_PATH=""
if [ -e "$MOUNT_PATH/boot/loader" ]; then
	BOOT_PATH="boot"
	OS="SLES9"
fi
if [ -e "$MOUNT_PATH/boot/x86_64/loader" ]; then
	BOOT_PATH="boot/x86_64"
	OS="SLES10"
fi
if [ -z "$BOOT_PATH" ]; then
	echo "Boot loader not found"
	exit 1
fi

# Copy the contents of the iso to a new location
echo "Copying Contents from: $MOUNT_PATH to $MOUNT_PATH_NEW"
cp -r $MOUNT_PATH/* $MOUNT_PATH_NEW/
if [ $? -ne 0 ]; then
	echo "could not copy contents of the iso"
	cleanup
fi

if [ "$ProductNameShort" = "N8000" ]; then
	cd $MOUNT_PATH_NEW
	num=`grep -n "Symantec License Agreement" ./control.xml | cut -d ":" -f1`
	sed -i `echo $num`,+11d ./control.xml
	num=`grep -n -A28 "SFS Driver Update" ./control.xml | grep -A1 "Time Zone" | awk 'NR==1'| cut -d "-" -f1`
	sed -i `echo $num`,+8d ./control.xml
	cd - > /dev/null
fi

if [ "$DefaultInstall" == "1" ]; then
	set -x
	echo changing default to harddisk
	sed -i 's/default harddisk/default linux/g' $MOUNT_PATH_NEW/boot/x86_64/loader/isolinux.cfg
	cd $MOUNT_PATH_NEW
	num=`grep -n "Edition Selection" ./control.xml | cut -d ":" -f1`
	sed -i `echo $num`,+17d ./control.xml
	num=`grep -n "Time Zone" ./control.xml | cut -d ":" -f1 | awk 'NR==1'`
	sed -i `echo $num`,+8d ./control.xml
	num=`grep -n "Time Zone" ./control.xml | cut -d ":" -f1 | awk 'NR==1'`
	! [ -z "$num" ] && sed -i `echo $num`,+8d ./control.xml
	cp ./control.xml /tmp
	cd - > /dev/null
	# Need to modify the name shown during the first input screen.
	# The ycp is part of archive of type cramfs, mount the archive and 
	# modify the contents on a different location, and overwrite with 
	# new values
	t_mountPath="$MOUNT_PATH_NEW/$BOOT_PATH/root_old.$$"
	t_newPath="$MOUNT_PATH_NEW/$BOOT_PATH/new_$$"
	mkdir $t_mountPath
	mount -o loop $MOUNT_PATH/$BOOT_PATH/root $t_mountPath
	cp -r $t_mountPath $t_newPath 2> /dev/null
	umount $t_mountPath
	rmdir $t_mountPath
	cd $t_newPath
	file="./usr/share/YaST2/clients/inst_sfs_config.ycp"

	sed -i 's/ret = get_config_input/ret = get_config_input_autoinstall/g' $file
	sed -i "s;any get_config_input_debug\(\);any get_config_input_autoinstall\(\) YYY\
	      \`\`{ YYY\
			any ret = nil\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.GATEWAYNAME,	\"$GATEWAYNAME\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.NNODES,	\"$NNODES\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.PIPSTART,	\"$PIPSTART\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.PIPMASK,	\"$PIPMASK\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.VIPSTART,	\"$VIPSTART\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.VIPMASK,	\"$VIPMASK\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.CONSIP,	\"$CONSIP\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.NTPSERVER,	\"$NTPSERVER\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.PCIEXCLUSIONID,     \"$PCIEXCLUSIONID\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.SEPCONSOLE,	\"$SEPCONSOLE\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.DNS,		\"$DNS\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.GATEWAY,	\"$GATEWAY\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.DOMAINNAME,	\"$DOMAINNAME\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.SINGLENODE,	\"$SINGLENODE\"\)\; YYY\
			SCR::Write\( .tmp.sfsinstall_conf.MODE,		\"new\"\)\; YYY\
			SCR::Write \( .tmp.sfsinstall_conf,		\"force\"\)\; YYY\
			ret = \`next\;  YYY\
			return ret\; YYY\
		}\; YYY\
	define any get_config_input_debug;g" $file
	sed -i 's/YYY/\n/g' $file
	cp $file /tmp
	cd - > /dev/null

	# Recreate the archive and update it
	$MKFS -t cramfs $t_newPath $MOUNT_PATH_NEW/$BOOT_PATH/newroot 
	mv $MOUNT_PATH_NEW/$BOOT_PATH/newroot $MOUNT_PATH_NEW/$BOOT_PATH/root
	rm -rf $t_newPath

	set +x
fi

if [ -e $MOUNT_PATH_NEW/oem.conf ]; then
	. $MOUNT_PATH_NEW/oem.conf
	OLD_PRODUCT_NAME=$PRODUCT_NAME
	OLD_PRODUCT_NAME_SHORT=$PRODUCT_NAME_SHORT
fi

if [ "$LogoModify" == "1" ]; then
	# Logos need to be modified
	echo "Modifying Logo files"

	# Modify the boot time logos
	cp $LogoDir/silent* $MOUNT_PATH_NEW/symc/install/install_server/etc/bootsplash/themes/SuSE-SLES/images/   2>/dev/null
	cp $LogoDir/bootsplash* $MOUNT_PATH_NEW/symc/install/install_server/etc/bootsplash/themes/SuSE-SLES/images/ 2>/dev/null
	# Modify the install time logos
	if [ "$OS" == "SLES9" ]; then
		cp $LogoDir/*.spl $MOUNT_PATH_NEW/$BOOT_PATH/loader
	else
		cp -f $LogoDir/silent-800x600.jpg $MOUNT_PATH_NEW/$BOOT_PATH/loader/welcome.jpg
		cp -f $LogoDir/silent-800x600.jpg $MOUNT_PATH_NEW/$BOOT_PATH/loader/back.jpg
	fi
fi

if [ "$ProductNameModify" == "1" ]; then
	echo "Modifying product name.."
	# Modify the product name in the man pages
	cd $MOUNT_PATH_NEW/$MAN_DIR
	sed -i "s/$OLD_PRODUCT_NAME/$ProductName/gi" *
	cd - > /dev/null

	echo "Updating product name in oem.conf.."

	# Replace the product name in oem.conf with the new name supplied
	tmpfile="/tmp/oem.conf_tmp.$$"
	[ -e $MOUNT_PATH_NEW/oem.conf ] && grep -v 'PRODUCT_NAME=' $MOUNT_PATH_NEW/oem.conf > $tmpfile
	echo "PRODUCT_NAME=\"$ProductName\"" >> $tmpfile
	mv $tmpfile $MOUNT_PATH_NEW/$OEM_CONF_FILE

	echo "Updating product name in installation screens"
	cd $MOUNT_PATH_NEW
	sed -i "s/Symantec FileStore/$ProductName/gi" $PRODUCT_NAME_LIST
	sed -i "s/$OLD_PRODUCT_NAME/$ProductName/gi" $PRODUCT_NAME_LIST
	cd - > /dev/null

	# Need to modify the name shown during the first input screen.
	# The ycp is part of archive of type cramfs, mount the archive and 
	# modify the contents on a different location, and overwrite with 
	# new values
	t_mountPath="$MOUNT_PATH_NEW/$BOOT_PATH/root_old.$$"
	t_newPath="$MOUNT_PATH_NEW/$BOOT_PATH/new_$$"
	mkdir $t_mountPath
	mount -o loop $MOUNT_PATH/$BOOT_PATH/root $t_mountPath
	cp -r $t_mountPath $t_newPath 2> /dev/null
	umount $t_mountPath
	rmdir $t_mountPath
	cd $t_newPath
	if [ -f ./usr/share/YaST2/clients/inst_${ProductNameShort}_select_edition.ycp ]; then
		sed -i "s/select_edition/${ProductNameShort}_select_edition/" $MOUNT_PATH_NEW/control.xml
		e_file="./usr/share/YaST2/clients/inst_${ProductNameShort}_select_edition.ycp"
	else
		e_file="./usr/share/YaST2/clients/inst_select_edition.ycp"
	fi
	
	sed -i "s/$OLD_PRODUCT_NAME/$ProductName/gi" $e_file
	sed -i "s/$OLD_PRODUCT_NAME_SHORT/$ProductNameShort/gi" $e_file
	sed -i "s/FileStore/$ProductNameShort/gi" $e_file

	u_file="./usr/share/YaST2/clients/inst_driver_update.ycp"
	sed -i "s/$OLD_PRODUCT_NAME/$ProductName/gi" $u_file
	sed -i "s/$OLD_PRODUCT_NAME_SHORT/$ProductNameShort/gi" $u_file

	if [ -f ./usr/share/YaST2/clients/inst_${ProductNameShort}_config.ycp ]; then
		t_files="./usr/share/YaST2/clients/inst_${ProductNameShort}_config.ycp"
		sed -i "s/sfs_config/${ProductNameShort}_config/" $MOUNT_PATH_NEW/control.xml
	else
		t_files="./usr/share/YaST2/clients/inst_sfs_config.ycp"
	fi
	sed -i "s/Symantec FileStore/$ProductName/gi" $t_files
	sed -i "s/$OLD_PRODUCT_NAME/$ProductName/gi" $t_files
	cd - > /dev/null

	# Recreate the archive and update it
	$MKFS -t cramfs $t_newPath $MOUNT_PATH_NEW/$BOOT_PATH/newroot 
	mv $MOUNT_PATH_NEW/$BOOT_PATH/newroot $MOUNT_PATH_NEW/$BOOT_PATH/root
	rm -rf $t_newPath
fi

if [ "$ProductVendorModify" == "1" ]; then
	echo "Modifying product vendor"

	tmpfile="/tmp/oem.conf_tmp.$$"
	[ -e $MOUNT_PATH_NEW/oem.conf ] && grep -v 'PRODUCT_VENDOR=' $MOUNT_PATH_NEW/oem.conf > $tmpfile
	echo "PRODUCT_VENDOR=\"$ProductVendor\"" >> $tmpfile
	mv $tmpfile $MOUNT_PATH_NEW/$OEM_CONF_FILE
fi

if [ "$DISABLE_PASSWD_CHANGE_PROMPT" == "1" ]; then
        echo "Disable default password change"

        tmpfile="/tmp/oem.conf_tmp.$$"
        [ -e $MOUNT_PATH_NEW/oem.conf ] && grep -v 'DISABLE_PASSWD_CHANGE_PROMPT=' $MOUNT_PATH_NEW/oem.conf > $tmpfile
	echo "DISABLE_PASSWD_CHANGE_PROMPT=\"1\"" >> $tmpfile
        mv $tmpfile $MOUNT_PATH_NEW/$OEM_CONF_FILE
fi

if [ "$GUI_URL_DISABLE" == "1" ]; then
	echo "Disable gui url in startup.sh"
	tmpfile="/tmp/oem.conf_tmp.$$"
	[ -e $MOUNT_PATH_NEW/oem.conf ] && grep -v 'GUI_URL_DISABLE=' $MOUNT_PATH_NEW/oem.conf > $tmpfile
	echo "GUI_URL_DISABLE=\"1\"" >> $tmpfile
	mv $tmpfile $MOUNT_PATH_NEW/$OEM_CONF_FILE
fi

if [ "$CHANGE_MIB" == "1" ];then
	snmp_suffix="GenericEventTrap"	
	echo "Updating MIB file" 
	cp $MIB_FILE $MOUNT_PATH_NEW/symc/nasg/scripts/sfsfs_mib.txt
	echo "MOdify event_notify.sh"
	sed -i "s/SYMC-SFSFS-MIB/$ProductVendor-MIB/gi" $MOUNT_PATH_NEW/symc/nasg/scripts/event_notify.sh
	sed -i "s/sfsfsGenericEventTrap/$ProductVendor$snmp_suffix/gi" $MOUNT_PATH_NEW/symc/nasg/scripts/event_notify.sh
	sed -i "s/SYMC-SFSFS-MIB/$ProductVendor-MIB/gi" $MOUNT_PATH_NEW/symc/nasg/scripts/snmp.conf.txt
fi

if [ "$ProductNameShortModify" == "1" ]; then
	echo "Modifying product short name"

	# Modify the name in man pages and other scripts which cannot 
	# read the value from oem.conf file
	cd $MOUNT_PATH_NEW
	echo "Modifying man pages"
	sed -i "s/$OLD_PRODUCT_NAME_SHORT/$ProductNameShort/g" $MAN_DIR/*
	
	echo "Modifying other files"
	sed -i "s/$OLD_PRODUCT_NAME_SHORT/$ProductNameShort/g" $PRODUCT_NAME_SHORT_LIST
	sed -i "s/$OLD_PRODUCT_NAME/$ProductNameShort/g" $PRODUCT_NAME_TO_SHORT_NAME_LIST
	cd - > /dev/null
	
	# Update the short name in the oem.conf file
	echo "Updating product short name in oem.conf"
	tmpfile="/tmp/oem.conf_tmp.$$"
	[ -e $MOUNT_PATH_NEW/oem.conf ] && grep -v 'PRODUCT_NAME_SHORT=' $MOUNT_PATH_NEW/oem.conf > $tmpfile
	echo "PRODUCT_NAME_SHORT=$ProductNameShort" >> $tmpfile
	mv $tmpfile $MOUNT_PATH_NEW/$OEM_CONF_FILE
fi

if [ "$BannerModify" == "1" ]; then
	echo "Modifying banner file"
	# Copy the new banner file into the iso
	cp $BannerPath $MOUNT_PATH_NEW/banner	
fi

if [ "$BootlogoModify" == "1" ]; then
	echo "Modifying bootlogo"
        cp -f $BootlogoPath $MOUNT_PATH_NEW/boot/x86_64/loader 
fi


if [ "$VersionModify" == "1" ]; then
	echo "Modifying version information"
	patch_description_file="$MOUNT_PATH_NEW/symc/nasg/scripts/patch_description.sh"
	. $patch_description_file
	new_version=`cat $VersionMapFilePath|vword=$SFS_PATCH_VERSION_WORD awk -F "=" '{vword=ENVIRON["vword"]; if ($1 == vword) {print $2}}'`
	if [ "X$new_version" != "X" ]; then
		sed -i "s/SFS_PATCH_VERSION_WORD=[^$]*/SFS_PATCH_VERSION_WORD=\"$new_version\"/g" $patch_description_file
	fi
fi

if [ "$GUIModify" == "1" ]; then
	echo "Modifying GUI Information"
	set -x
	# Plugin directory changes.
	GUI_PLUGIN_FILES='login_about_name.gif  product_header.gif'
	for filename in $GUI_PLUGIN_FILES; do
	cp $GUIDir/${filename} $MOUNT_PATH_NEW/symc/nasg/gui/plugins/sfs/images/${filename}   2>/dev/null
	done
	
	# online Help file changes. Note that the name of the file should be
	# SymantecLogo.gif only, otherwise esmweb will not take it.
	cp $GUIDir/SymantecLogo.gif $MOUNT_PATH_NEW/symc/nasg/gui/images/SymantecLogo.gif
	cp $GUIDir/LogoFill.gif $MOUNT_PATH_NEW/symc/nasg/gui/images/LogoFill.gif 
	
	# ESM_TAR_BALL changes
	ESM_TAR_BALL=`ls ${MOUNT_PATH_NEW}/symc/nasg/third_party_packages/esmweb* | head -1` 
	tar -xf ${ESM_TAR_BALL}
	cp $GUIDir/about_header.gif esmweb/webgui/sm/vmgmt-static/images/about_header.gif
	cp $GUIDir/head_bkgrnd.gif esmweb/webgui/sm/vmgmt-static/images/head_bkgrnd.gif
	cp $GUIDir/vlim-login-back.gif esmweb/webgui/sm/images/vlim-login-back.gif
	cp $GUIDir/footer_bkgrnd.gif   esmweb/webgui/sm/images/footer_bkgrnd.gif
	cp $GUIDir/login_bg.gif        esmweb/webgui/sm/images/login_bg.gif
	tar -cf ${ESM_TAR_BALL} esmweb
	
	# Clean up
	rm -rf esmweb
	
	set +x
fi

if [ "$PluginModify" == "1" ]; then
	echo "Adding the plguins"
	$ADD_PLUGIN_TOOL $PluginFilePath $MOUNT_PATH_NEW
	if [ $? -ne 0 ]; then
		echo "Fail to add the plugins. Abort"
		exit 1
	fi
fi

if [ "$License_Disable" == "1" ]; then
	echo "Disabling license information"
	cd $MOUNT_PATH_NEW
	num=`grep -n "Symantec License Agreement" ./control.xml | cut -d ":" -f1`
	sed -i `echo $num`,+11d ./control.xml
	cd - > /dev/null
fi

# Rebuild the iso using the same arguments as with build.sh, but do not add
# Publisher and Preparer fileds in the ISO 
echo "Creating New iso : $NewImagePath "
VOLID=$ProductNameShort
[ -z "$VOLID" ] && VOLID=$OLD_PRODUCT_NAME
$MKISOFS -v -D -V "$VOLID" -r -J -l -L  			\
	-b "$BOOT_PATH/loader/isolinux.bin" -c "$BOOT_PATH/loader/boot.cat"		\
	-no-emul-boot -boot-load-size 4 -boot-info-table -graft-points	\
	-log-file mkisofs.log -o $NewImagePath $MOUNT_PATH_NEW 2> /dev/null

cleanup
echo "ISO Created: $NewImagePath "

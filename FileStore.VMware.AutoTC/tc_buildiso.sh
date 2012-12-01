#!/bin/bash

set -x
ssh="ssh -n"

TC_SCRIPTS_DIR=/mnt/sdd1/tc
TC_VMWARE_DIR=/mnt/sdd1/vmware
$ssh bkancher@sfsweb.vxindia.veritas.com ./tc/buildiso.sh /vx/sfs_home/bkancher/build/tc_build
rm $TC_VMWARE_DIR/base_image.iso
scp -r bkancher@sfsweb.vxindia.veritas.com:/vx/sfs_home/bkancher/build/tc_build/target/image.iso $TC_VMWARE_DIR/base_image.iso
rm $TC_VMWARE_DIR/image.iso
$TC_SCRIPTS_DIR/oem-core.sh -product_password_disable -default-install $TC_SCRIPTS_DIR/sfsinstall.conf $TC_VMWARE_DIR/base_image.iso $TC_VMWARE_DIR/image.iso


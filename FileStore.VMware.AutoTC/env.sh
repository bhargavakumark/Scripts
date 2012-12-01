# .bashrc

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/root/PRM/prm.tusharb/OST-SDK-11.1.0/tools/usr/openv/lib"

export TC_DIR=/mnt/sdd1/tc/TC_ndmpd                          #TC Directory Path
export PERL5LIB=$PERL5LIB:$TC_DIR/lib                            #VCS LIB PATH
export TEST_RESULTS_DIR=/mnt/sdd1/tc/tc_result/             #CHANGE IT YOUR Result Test Dir.
export VCS_TC_SYSCOUNT=2                               #Number of nodes in the cluster
#export VCS_TC_SYS01=nasgw12_01 #This is management console IP
#export VCS_TC_SYS02=nasgw12_02 #This is second node of the cluster
export VCS_TC_SYS01=autotc_01		#This is management console IP
export VCS_TC_SYS02=autotc_02
export VCS_TC_CONN_DEBUG=1
export HOST_DOWN_CHECK=1
export VCS_TC_CONN_TIMEOUT=60
export TC_ISCSI_INIT_DISC_ADDR="192.168.30.2:3260"
export TC_ISCSI_INIT_DISC_ADDR_JUNK="192.168.30.254:3260"
export TC_ISCSI_INIT_DISC_ADDR_NOPORT="192.168.30.2"
export TC_ISCSI_INIT_DISC_ADDR_DIFFPORT="192.168.30.2:3261"
export TC_ISCSI_INIT_DEVICE_1="pubeth1"
export TC_ISCSI_INIT_DEVICE_2="pubeth0"
export TC_ISCSI_INIT_DEVICE_NONEXIST="pubeth8"
export TC_HTTP_FS="general_fs1"
export TC_FTP_FS="general_fs1"

#For NTP Test Cases set the ntp servername
export NTP_SERVER_NAME=10.143.225.25

# NIS Test Cases
export VCS_TC_NIS_SERVER=10.216.128.243                # NIS Server: vmlxpx1.vxindia.veritas.com
export VCS_TC_NIS_DOMAIN=vxindia.veritas.com           # NIS Domain Name
export VCS_TC_NIS_USER=tcuser0123456789                # NIS Username

alias trun="$TC_DIR/bin/trun"

##### LDAP client test cases #####
# LDAP server: sanfsx2100-02.vxindia.veritas.com
export VCS_TC_LDAP_SERVER=10.216.113.11
# LDAP base DN
export VCS_TC_LDAP_BASEDN="dc=vxindia,dc=veritas,dc=com"
# LDAP bind DN
export VCS_TC_LDAP_BINDDN="cn=binduser,dc=vxindia,dc=veritas,dc=com"
# LDAP bind DN's password
export VCS_TC_LDAP_BINDPW=binduser
# LDAP root bind DN
export VCS_TC_LDAP_ROOTBINDDN="cn=admin,dc=vxindia,dc=veritas,dc=com"
# LDAP root bind DN's password
export VCS_TC_LDAP_ROOTBINDPW=admin
# LDAP users based DN
export VCS_TC_LDAP_USERS_BASEDN="ou=People,dc=vxindia,dc=veritas,dc=com"
# LDAP groups base DN
export VCS_TC_LDAP_GROUPS_BASEDN="ou=Group,dc=vxindia,dc=veritas,dc=com"
# LDAP user
export VCS_TC_LDAP_USER=tcuser0987654321
export TAPE_DEVICE_NOREWIND="12345"
export TAPE_DEVICE_REWIND="12345"
export TC_NDMP_DATA_SERVER_IP="192.168.30.253"
export TC_NDMP_DATA_SERVER_PORT="10000"
export TC_NDMP_DATA_USERNAME="master"
export TC_NDMP_DATA_PASSWORD="master"
export TC_NDMP_TAPE_USERNAME="root"
export TC_NDMP_TAPE_PASSWORD="root123"
export TC_NDMP_TAPE_SERVER_IP="192.168.30.1"
export TC_NDMP_TAPE_SERVER_PORT="10000"
export TC_NDMP_BACKUP_FS_1="ndmp_fs1"
export TC_NDMP_BACKUP_FS_2="ndmp_fs2"
export TC_NDMP_BACKUP_FS_3="ndmp_fs3"
export TC_NDMP_BACKUP_FS_4="ndmp_fs4"

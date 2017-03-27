#!/bin/bash
################################################################################
#
# (RHEL_STIG_Baseline)/RHEL/RHEL_Misc_configs.sh
#
# Created by:  Matthew R. Sawyer
#
# This script corrects several miscellaneous STIG and functionality corrections.
#
################################################################################
#
# This script will correct the following STIG Items:
#	RHEL-06-000027	V-38492
#	RHEL-06-000069	V-38586
#	RHEL-06-000070	V-38588
#	RHEL-06-000272	V-38656
#	RHEL-06-000308	V-38675
#	RHEL-06-000319	V-38684
#	RHEL-06-000334	V-38692
#	RHEL-06-000340	V-38660
#	RHEL-06-000509	V-38471
#	RHEL-06-000290	V-38674
#	RHEL-06-000286	V-38668
#
# This script will perform some correction for the following:
#	RHEL-06-000135	V-38623
#
################################################################################
# Environment Variable
################################################################################

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ ! -f ${BASE_DIR}/../Baseline_Variables.sh ]];then
  printf "\e[0;31mERROR:\e[0m\tThe Enclaves_variables.sh script is not available\n\n"
  exit
else
  source ${BASE_DIR}/../Baseline_Variables.sh
fi

set_variables
root_uid_check
backup_dir_check

################################################################################
# Function - RHEL 6 Settings
################################################################################

rhel_6_misc_config ()
{

printf "This is not yet configured, TBD\n"
end_script

}

################################################################################
# Function - RHEL 7 Settings
################################################################################

rhel_7_misc_config ()
{

# Introduction
printf "===== RHEL 7 - Miscellaneous configurations =====\n\n"

# Backup settings
printf "+ Backing up old configurations now\n"

# /etc/securetty
if [[ -f ${BACKUP_DIR}/etc.securetty.${CUR_DATE} ]];then
  /bin/cp /etc/securetty ${BACKUP_DIR}/etc.securetty.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp /etc/securetty ${BACKUP_DIR}/etc.securetty.${CUR_DATE}
fi

# /etc/sysconfig/init
if [[ -f ${BACKUP_DIR}/etc.sysconfig.init.${CUR_DATE} ]];then
  /bin/cp /etc/sysconfig/init ${BACKUP_DIR}/etc.sysconfig.init.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp /etc/sysconfig/init ${BACKUP_DIR}/etc.sysconfig.init.${CUR_DATE}
fi

# /etc/samba/smb.conf
if [[ -f ${BACKUP_DIR}/etc.samba.smb.conf.${CUR_DATE} ]];then
  /bin/cp /etc/samba/smb.conf ${BACKUP_DIR}/etc.samba.smb.conf.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp /etc/samba/smb.conf ${BACKUP_DIR}/etc.samba.smb.conf.${CUR_DATE}
fi

# /etc/security/limits.conf
if [[ -f ${BACKUP_DIR}/etc.security.limits.conf.${CUR_DATE} ]];then
  /bin/cp /etc/security/limits.conf ${BACKUP_DIR}/etc.security.limits.conf.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp /etc/security/limits.conf ${BACKUP_DIR}/etc.security.limits.conf.${CUR_DATE}
fi

# /etc/default/useradd
if [[ -f ${BACKUP_DIR}/etc.default.useradd.${CUR_DATE} ]];then
  /bin/cp /etc/default/useradd ${BACKUP_DIR}/etc.default.useradd.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp /etc/default/useradd ${BACKUP_DIR}/etc.default.useradd.${CUR_DATE}
fi

# /etc/snmp/snmpd.conf
if [[ -f ${BACKUP_DIR}/etc.snmp.snmpd.conf.${CUR_DATE} ]];then
  /bin/cp /etc/snmp/snmpd.conf ${BACKUP_DIR}/etc.snmp.snmpd.conf.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp /etc/snmp/snmpd.conf ${BACKUP_DIR}/etc.snmp.snmpd.conf.${CUR_DATE}
fi

# /etc/audisp/plugins.d/syslog.conf
if [[ -f ${BACKUP_DIR}/etc.audisp.plugins.d.syslog.conf.${CUR_DATE} ]];then
  /bin/cp /etc/audisp/plugins.d/syslog.conf ${BACKUP_DIR}/etc.audisp.plugins.d.syslog.conf.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp /etc/audisp/plugins.d/syslog.conf ${BACKUP_DIR}/etc.audisp.plugins.d.syslog.conf.${CUR_DATE}
fi

# /etc/rc.d/rc.local
if [[ -f ${BACKUP_DIR}/etc.rc.d.rc.local.${CUR_DATE} ]];then
  /bin/cp /etc/rc.d/rc.local ${BACKUP_DIR}/etc.rc.d.rc.local.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp /etc/rc.d/rc.local ${BACKUP_DIR}/etc.rc.d.rc.local.${CUR_DATE}
fi

# SeLinux Context tags
printf "\n"
printf "+ Configuring Selinux Tags\n"

if [[ ${ADMIN_HOMEDIR} == "admin_homedir" ]];then
  printf "\n\e[0;33mNOTICE:\e[0m\tThe Admin home directory is not set.  Some selinux tags will not be set.\n\n"
elif [[ -n `echo ${ADMIN_HOMEDIR} | grep '^/local_home'` ]];then
  /sbin/semanage fcontext -a -t home_root_t '/local_home'
  /sbin/semanage fcontext -a -t user_home_dir_t "${ADMIN_HOMEDIR}"
  /sbin/semanage fcontext -a -t user_home_t "${ADMIN_HOMEDIR}/\.bash_history"
  /sbin/semanage fcontext -a -t user_home_t "${ADMIN_HOMEDIR}/\.bash_logout"
  /sbin/semanage fcontext -a -t user_home_t "${ADMIN_HOMEDIR}/\.bash_profile"
  /sbin/semanage fcontext -a -t user_home_t "${ADMIN_HOMEDIR}/\.bashrc"
  /sbin/restorecon -RFvv /local_home
else
  printf "\n\e[0;33mNOTICE:\e[0m\tThe Admin home directory is not based under \'/local_home\'.  Some selinux tags will not be set.\n\n"
fi

/sbin/setsebool -P use_nfs_home_dirs 1

# Correcting RHEL-06-000027
printf "+ Correcting RHEL-06-000027\n"
sed -i '/vc\/[0-9]/d' /etc/securetty

# Correcting RHEL-06-000069
printf "+ Correcting RHEL-06-000069\n"
if [[ -n `cat /etc/sysconfig/init | grep "SINGLE=/sbin/sulogin"` ]];then
  printf "\n\e[0;33mNOTICE:\e[0m\tThis setting has already been corrected\n\n"
else
  printf "# STIG ID RHEL-06-000069\nSINGLE=/sbin/sulogin\n" >> /etc/sysconfig/init
fi

# Correcting RHEL-06-000070
printf "+ Correcting RHEL-06-000070\n"
if [[ -n `cat /etc/sysconfig/init | grep "PROMPT=no"` ]];then
  printf "\n\e[0;33mNOTICE:\e[0m\tThis setting has already been corrected\n\n"
else
  printf "# STIG ID RHEL-06-000070\nPROMPT=no\n" >> /etc/sysconfig/init
fi

# Correcting RHEL-06-000272
printf "+ Correcting RHEL-06-000272\n"
if [[ -n `cat /etc/samba/smb.conf | grep "client signing = mandatory"` ]];then
  printf "\n\e[0;33mNOTICE:\e[0m\tThis setting has already been corrected\n\n"
else
  sed -i '/^\[global\]/a client signing = mandatory' /etc/samba/smb.conf
fi

# Correcting RHEL-06-000308
printf "+ Correcting RHEL-06-000308\n"
if [[ -n `cat /etc/security/limits.conf | grep 'hard' | grep 'core' | grep '0' | grep '\*'` ]];then
  printf "\n\e[0;33mNOTICE:\e[0m\tThis setting has already been corrected\n\n"
else
  sed -i '/End of file/d' /etc/security/limits.conf
  printf "*\t\thard\tcore\t\t0\n" >> /etc/security/limits.conf
fi

# Correcting RHEL-06-000319
printf "+ Correcting RHEL-06-000319\n"
if [[ -n `cat /etc/security/limits.conf | grep 'hard' | grep 'maxlogins' | grep '10' | grep '\*'` ]];then
  printf "\n\e[0;33mNOTICE:\e[0m\tThis setting has already been corrected\n\n"
else
  printf "*\t\thard\tmaxlogins\t10\n" >> /etc/security/limits.conf
fi

# Correcting RHEL-06-000334
printf "+ Correcting RHEL-06-000334\n"
if [[ -n `cat /etc/default/useradd | grep "INACTIVE=35"` ]];then
  printf "\n\e[0;33mNOTICE:\e[0m\tThis setting has already been corrected\n\n"
elif [[ -z `cat /etc/default/useradd | grep "INACTIVE=-1"` ]];then
  printf "\n\e[0;33mNOTICE:\e[0m\tThis setting has been modified from the original, skipping!\n\n"
else
  sed -i 's/INACTIVE\=\-1/INACTIVE\=35/' /etc/default/useradd 
fi

# Correcting RHEL-06-000340
printf "+ Correcting RHEL-06-000340\n"
sed -i '/com2sec\ /d' /etc/snmp/snmpd.conf
sed -i '/^group.*\ v1\ /d' /etc/snmp/snmpd.conf
sed -i '/^group.*\ v2c\ /d' /etc/snmp/snmpd.conf
/sbin/service snmpd restart

# Correcting RHEL-06-000509
printf "+ Correcting RHEL-06-000509\n"
if [[ -n `cat /etc/audisp/plugins.d/syslog.conf | grep "active = yes"` ]];then
  printf "\n\e[0;33mNOTICE:\e[0m\tThis setting has already been corrected\n\n"
else
  sed -i 's/^active \= no/active \= yes/' /etc/audisp/plugins.d/syslog.conf
fi

# Correcting part of RHEL-06-000135
printf "+ Correcting part of RHEL-06-000135\n"
if [[ -n `cat /etc/rc.d/rc.local | grep "chmod 0600 /var/log/boot.log"` ]];then
  printf "\n\e[0;33mNOTICE:\e[0m\tThis setting has already been corrected\n\n"
else
  echo "chmod 0600 /var/log/boot.log" >> /etc/rc.d/rc.local 
  chmod u+x /etc/rc.d/rc.local 
  /bin/chown root:root /var/log/boot.log
  chmod 0600 /var/log/boot.log
fi

# Correcting RHEL-06-000290
printf "+ Correcting RHEL-06-000290\n"
  /bin/systemctl set-default multi-user.target 

# Correcting RHEL-06-000286
printf "+ Correcting RHEL-06-000286\n"
  /bin/systemctl mask ctrl-alt-del.target

# Report Completion
printf "\n"
printf "===== Configurations complete =====\n"

}

################################################################################
# Choose the function based on Architecture
################################################################################

if [[ `uname -s` != "Linux" ]];then
  printf "\n\e[0;31mERROR\e[0m\tThis script does not have a valid check for non Linux systems yet!\n"
  end_script
elif [[ -n `uname -r | egrep '.el6.'` ]];then
  if [[ -n `cat /etc/redhat-release | grep 'Red Hat Enterprise Linux Server release 6'` ]];then
    rhel_6_misc_config
    end_script
  else
    printf "\n\e[0;31mERROR\e[0m\tThere is a mismatch between the kernel and release versions, please investigate!\n"
    end_script
  fi
elif [[ -n `uname -r | egrep '.el7.'` ]];then
  if [[ -n `cat /etc/redhat-release | grep 'Red Hat Enterprise Linux Server release 7'` ]];then
    rhel_7_misc_config
    end_script
  else
    printf "\n\e[0;31mERROR\e[0m\tThere is a mismatch between the kernel and release versions, please investigate!\n"
    end_script
  fi
fi

################################################################################
# End of Script
################################################################################

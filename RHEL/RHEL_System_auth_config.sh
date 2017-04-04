#!/bin/bash
################################################################################
#
# (RHEL_STIG_Baseline)/RHEL/RHEL_System_auth_config.sh
#
# Created by:  Matthew Ryan Sawyer
#
# This is designed to ensure STIG compliance for system authentication related
# checks.  This modifies the system-auth, password-auth, pwquality.conf, and
# login.def files.
#
################################################################################
#
# This script will correct the following STIG Items:
#  /etc/login.defs
#	      RHEL-06-000050  V-38475
#	      RHEL-06-000051  V-38477
#	      RHEL-06-000053  V-38479
#	      RHEL-06-000054  V-38480
#       RHEL-06-000063  V-38576
#	      RHEL-06-000345  V-38645
#  /etc/pwquality.conf
#       RHEL-06-000050	V-38475
#       RHEL-06-000056  V-38482
#       RHEL-06-000057  V-38569
#       RHEL-06-000058  V-38570
#       RHEL-06-000059  V-38571
#       RHEL-06-000060  V-38572
#       RHEL-06-000299  V-38693
#  /etc/pam.d/system-auth and /etc/pam.d/password-auth
#       RHEL-06-000030  V-38497
#       RHEL-06-000061  V-38573
#       RHEL-06-000062  V-38574
#       RHEL-06-000274  V-38658
#       RHEL-06-000356  V-38592
#       RHEL-06-000357  V-38501
#       RHEL-06-000372  V-51875
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

rhel_6_system_auth_config ()
{

printf "This is not yet configured, TBD\n"
end_script

}

################################################################################
# Function - RHEL 7 Settings
################################################################################

rhel_7_system_auth_config ()
{

# Establish Variables
LOGIN_DEFS=/etc/login.defs
LOGIN_TEMPLATE=${BASE_DIR}/7/template.etc.login.defs
PWQUALITY_CONF=/etc/security/pwquality.conf
PWQUALITY_TEMPLATE=${BASE_DIR}/7/template.etc.security.pwquality.conf
SYSTEM_AUTH=/etc/pam.d/system-auth
PASSWORD_AUTH=/etc/pam.d/password-auth
SYS_AUTH_LOCAL=/etc/pam.d/system-auth-local
SYS_AUTH_TEMPLATE=${BASE_DIR}/7/template.etc.pam.d.system.auth.local

# Verify the template files exists
if [[ ! -f ${LOGIN_TEMPLATE} ]] || [[ ! -f ${PWQUALITY_TEMPLATE} ]] || [[ ! -f ${SYS_AUTH_TEMPLATE} ]];then
  printf "\n\n\e[0;31mERROR:\e[0m\tThe template files are not accessible - aborting\n\n"
  end_script
fi

# Introduction
printf "===== RHEL 7 - System Authentication configurations =====\n\n"

# Backup settings
printf "+ Backing up old configurations now\n"

# /etc/login.defs
if [[ -f ${BACKUP_DIR}/etc.login.defs.${CUR_DATE} ]];then
  /bin/cp ${LOGIN_DEFS} ${BACKUP_DIR}/etc.login.defs.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp ${LOGIN_DEFS} ${BACKUP_DIR}/etc.login.defs.${CUR_DATE}
fi

# /etc/security/pwquality.conf
if [[ -f ${BACKUP_DIR}/etc.security.pwquality.conf.${CUR_DATE} ]];then
  /bin/cp ${PWQUALITY_CONF} ${BACKUP_DIR}/etc.security.pwquality.conf.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp ${PWQUALITY_CONF} ${BACKUP_DIR}/etc.security.pwquality.conf.${CUR_DATE}
fi

# /etc/pam.d/system-auth
if [[ -f ${BACKUP_DIR}/etc.pam.d.system.auth.${CUR_DATE} ]];then
  /bin/cp ${SYSTEM_AUTH} ${BACKUP_DIR}/etc.pam.d.system.auth.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp ${SYSTEM_AUTH} ${BACKUP_DIR}/etc.pam.d.system.auth.${CUR_DATE}
fi

# /etc/pam.d/password-auth
if [[ -f ${BACKUP_DIR}/etc.pam.d.password.auth.${CUR_DATE} ]];then
  /bin/cp ${PASSWORD_AUTH} ${BACKUP_DIR}/etc.pam.d.password.auth.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp ${PASSWORD_AUTH} ${BACKUP_DIR}/etc.pam.d.password.auth.${CUR_DATE}
fi

# Replace the existing configurations
printf "+ Replacing configurations\n"
/bin/cat ${LOGIN_TEMPLATE} > ${LOGIN_DEFS}
/bin/cat ${PWQUALITY_TEMPLATE} > ${PWQUALITY_CONF}
/bin/cat ${SYS_AUTH_TEMPLATE} > ${SYS_AUTH_LOCAL}
/bin/rm -f ${SYSTEM_AUTH}
/bin/rm -f ${PASSWORD_AUTH}
/bin/ln -s ${SYS_AUTH_LOCAL} ${SYSTEM_AUTH}
/bin/ln -s ${SYS_AUTH_LOCAL} ${PASSWORD_AUTH}

# Set permissions
printf "+ Updating Permissions\n"
/bin/chown root:root ${LOGIN_DEFS} ${PWQUALITY_CONF} ${SYS_AUTH_LOCAL}
chmod 644 ${LOGIN_DEFS} ${PWQUALITY_CONF} ${SYS_AUTH_LOCAL}

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
  if [[ -n `/bin/cat /etc/redhat-release | grep 'Red Hat Enterprise Linux Server release 6'` ]];then
    rhel_6_system_auth_config
    end_script
  else
    printf "\n\e[0;31mERROR\e[0m\tThere is a mismatch between the kernel and release versions, please investigate!\n"
    end_script
  fi
elif [[ -n `uname -r | egrep '.el7.'` ]];then
  if [[ -n `/bin/cat /etc/redhat-release | grep 'Red Hat Enterprise Linux Server release 7'` ]];then
    rhel_7_system_auth_config
    end_script
  else
    printf "\n\e[0;31mERROR\e[0m\tThere is a mismatch between the kernel and release versions, please investigate!\n"
    end_script
  fi
fi

################################################################################
# End of Script
################################################################################

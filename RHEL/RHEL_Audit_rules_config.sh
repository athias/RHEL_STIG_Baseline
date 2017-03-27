#!/bin/bash
################################################################################
#
# (RHEL_STIG_Baseline)/RHEL/RHEL_Audit_rules_config.sh
#
# Created by:  Matthew R. Sawyer
#
# This is designed to ensure STIG compliance for audit related checks.  This
# script can safely be re-run to update RHEL-06-000198 as configurations on the
# system change.
#
################################################################################
#
# This script will correct the following STIG Items:
#	RHEL-06-000165	V-38635
#	RHEL-06-000167	V-38522
#	RHEL-06-000169	V-38525
#	RHEL-06-000171	V-38527
#	RHEL-06-000173	V-38530
#	RHEL-06-000174	V-38531
#	RHEL-06-000175	V-38534
#	RHEL-06-000176	V-38536
#	RHEL-06-000177	V-38538
#	RHEL-06-000182	V-38540
#	RHEL-06-000183	V-38541
#	RHEL-06-000184	V-38543
#	RHEL-06-000185	V-38545
#	RHEL-06-000186	V-38547
#	RHEL-06-000187	V-38550
#	RHEL-06-000188	V-38552
#	RHEL-06-000189	V-38554
#	RHEL-06-000190	V-38556
#	RHEL-06-000191	V-38557
#	RHEL-06-000192	V-38558
#	RHEL-06-000193	V-38559
#	RHEL-06-000194	V-38561
#	RHEL-06-000195	V-38563
#	RHEL-06-000196	V-38565
#	RHEL-06-000197	V-38566
#	RHEL-06-000198	V-38567
#	RHEL-06-000199	V-38568
#	RHEL-06-000200	V-38575
#	RHEL-06-000201	V-38578
#	RHEL-06-000202	V-38580
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

rhel_6_audit_rules ()
{

printf "This is not yet configured, TBD\n"
end_script

}

################################################################################
# Function - RHEL 7 Settings
################################################################################

rhel_7_audit_rules ()
{

# Establish Variables
AUDIT_RULES=/etc/audit/rules.d/audit.rules
RULES_TEMPLATE=${BASE_DIR}/7/template.etc.audit.rules.d.audit.rules

# Introduction
printf "===== RHEL 7 - Audit.rules configurations =====\n\n"

# Verify the template files exists
if [[ ! -f ${RULES_TEMPLATE} ]];then
  printf "\e[0;31mERROR:\e[0m\tThe template file is not accessible - aborting\n\n"
  end_script
fi

# Backup settings
printf "+ Backing up old configurations now\n"

if [[ -f ${BACKUP_DIR}/etc.audit.rules.d.audit.rules.${CUR_DATE} ]];then
  /bin/cp ${AUDIT_RULES} ${BACKUP_DIR}/etc.audit.rules.d.audit.rules.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp ${AUDIT_RULES} ${BACKUP_DIR}/etc.audit.rules.d.audit.rules.${CUR_DATE}
fi

# Replace the existing configurations
printf "+ Replacing base configurations\n"
/bin/cat ${RULES_TEMPLATE} > ${AUDIT_RULES}

# Set permissions
printf "+ Updating Permissions\n"
/bin/chown root:root ${AUDIT_RULES}
chmod 600 ${AUDIT_RULES}

# Determining Local Disks and creating
printf "+ Finding and generating audits for setuid and setgid files\n"
LOCAL_DISKS=`/bin/lsblk -o MOUNTPOINT | egrep -v '^$|^MOUNTPOINT|^\[SWAP\]' | sort`
for CUR_DISK in ${LOCAL_DISKS};do
  for CUR_FILE in `/bin/find ${CUR_DISK} -xdev -type f -perm /6000 2>/dev/null`;do
    if [[ -f ${CUR_FILE} ]];then
      echo -e "-a always,exit -F path=${CUR_FILE} -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> ${AUDIT_RULES}
    else
      printf "\e[0;33mNOTICE:\e[0m\tThis file does not exist.  It likely has a space in the path:\n"
      printf "\t\t\t${CUR_FILE}\n\n"
    fi
  done
done

# Restart auditing
printf "\n"
printf "+ Restarting audit daemon\n"
service auditd restart

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
    rhel_6_audit_rules
    end_script
  else
    printf "\n\e[0;31mERROR\e[0m\tThere is a mismatch between the kernel and release versions, please investigate!\n"
    end_script
  fi
elif [[ -n `uname -r | egrep '.el7.'` ]];then
  if [[ -n `cat /etc/redhat-release | grep 'Red Hat Enterprise Linux Server release 7'` ]];then
    rhel_7_audit_rules
    end_script
  else
    printf "\n\e[0;31mERROR\e[0m\tThere is a mismatch between the kernel and release versions, please investigate!\n"
    end_script
  fi
fi

################################################################################
# End of Script
################################################################################

#!/bin/bash
################################################################################
#
# (RHEL_STIG_Baseline)/RHEL/RHEL_SSH_config.sh
#
# Created by:  Matthew R. Sawyer
#
# This is designed to set the SSH configurations to meet STIG complaince.
#
################################################################################
#
# This script will correct the following STIG Items:
#	RHEL-06-000227	V-38607
#	RHEL-06-000230	V-38608
#	RHEL-06-000231	V-38610
#	RHEL-06-000234	V-38611
#	RHEL-06-000236	V-38612
#	RHEL-06-000237	V-38613
#	RHEL-06-000239	V-38614
#	RHEL-06-000240	V-38615
#	RHEL-06-000241	V-38616
#	RHEL-06-000243	V-38617
#	RHEL-06-000507	V-38484
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

rhel_6_ssh_configs ()
{

printf "This is not yet configured, TBD\n"

end_script

}

################################################################################
# Function - RHEL 7 Settings
################################################################################

rhel_7_ssh_config ()
{

# Establish Variables
SSH_CONFIG=/etc/ssh/sshd_config
SSH_TEMPLATE=${BASE_DIR}/7/template.etc.ssh.sshd_config

# Introduction
printf "===== RHEL 7 - SSH configurations =====\n\n"

# Verify the template files exists
if [[ ! -f ${SSH_TEMPLATE} ]];then
  printf "\e[0;31mERROR:\e[0m\tThe template file is not accessible - aborting\n\n"
  end_script
fi

# Backup settings
printf "+ Backing up old configurations now\n"

if [[ -f ${BACKUP_DIR}/etc.ssh.sshd_config.${CUR_DATE} ]];then
  /bin/cp ${SSH_CONFIG} ${BACKUP_DIR}/etc.ssh.sshd_config.${CUR_DATE}.${CUR_TIME}
else
  /bin/cp ${SSH_CONFIG} ${BACKUP_DIR}/etc.ssh.sshd_config.${CUR_DATE}
fi

# Replace the existing configurations
printf "+ Replacing configurations\n"
/bin/cat ${SSH_TEMPLATE} > ${SSH_CONFIG}

# Set permissions
printf "+ Updating Permissions\n"
/bin/chown root:root ${SSH_CONFIG}
chmod 600 ${SSH_CONFIG}

# Allow The user to decide on forced-commands
printf "\n"
printf "Do you want to allow forced-commands for root over ssh?\n"
printf "Please note - you must POA&M this if you choose this option:\n"
printf "\tEnable forced-commands [Y/N]"
read yn
if [[ $yn =~ [Yy][Ee][Ss]|[Yy] ]];then
  sed -i 's/PermitRootLogin no/PermitRootLogin forced-commands-only/' ${SSH_CONFIG}
  sed -i '/PermitRootLogin forced-commands-only/a # This was modified for forced-commands and must be listed on a POA&M' ${SSH_CONFIG}
fi

# Restart sshd
printf "\n"
printf "+ Restarting ssh daemon\n"
/bin/systemctl restart sshd

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
    rhel_6_ssh_config
    end_script
  else
    printf "\n\e[0;31mERROR\e[0m\tThere is a mismatch between the kernel and release versions, please investigate!\n"
    end_script
  fi
elif [[ -n `uname -r | egrep '.el7.'` ]];then
  if [[ -n `cat /etc/redhat-release | grep 'Red Hat Enterprise Linux Server release 7'` ]];then
    rhel_7_ssh_config
    end_script
  else
    printf "\n\e[0;31mERROR\e[0m\tThere is a mismatch between the kernel and release versions, please investigate!\n"
    end_script
  fi
fi

################################################################################
# End of Script
################################################################################

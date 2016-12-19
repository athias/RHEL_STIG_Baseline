#!/bin/bash
################################################################################
#
# (RHEL_STIG_Baseline)/RHEL/RHEL_SSH_configs.sh
#	
# Created by:  Matthew R. Sawyer
#
# This script replaces the ${SSH_CONFIG} file with an appropriately STIG
# compliant version.  It also provides you the option of selecting certain
# settings that are commonly used for special purposes.
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

source /Sysadmin/baseline/Enclave_variables.sh
set_variables
root_uid_check

SSH_CONFIG=/etc/ssh/sshd_config

################################################################################
# Function - Settings Backup
################################################################################

backup_configs ()
{

# Verify Backup Directory is good
if [[ ! -d ${BACKUP_DIR} ]];then
  if [[ ! -d /root ]];then
    printf "\n\e[0;31mERROR:\e[0m\tRoot\'s home directory doesn't exist, quitting!\n"
    end_script
  fi
  mkdir ${BACKUP_DIR}
  chmod 700 ${BACKUP_DIR}
  chown root:root ${BACKUP_DIR}
fi

# Backup settings
if [[ -f ${BACKUP_DIR}/etc.ssh.sshd_config.${CUR_DATE} ]];then
  cp ${SSH_CONFIG} ${BACKUP_DIR}/etc.ssh.sshd_config.${CUR_DATE}.${CUR_TIME}
else
  cp ${SSH_CONFIG} ${BACKUP_DIR}/etc.ssh.sshd_config.${CUR_DATE}
fi

}

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

rhel_7_ssh_configs ()
{

# First line should always replace, not append
printf "################################################################################\n" > ${SSH_CONFIG}

# Start replacing the file
printf "#\n" >> ${SSH_CONFIG}
printf "# ${SSH_CONFIG}\n" >> ${SSH_CONFIG}
printf "#   chown root:root\n" >> ${SSH_CONFIG}
printf "#   chmod 600\n" >> ${SSH_CONFIG}
printf "#\n" >> ${SSH_CONFIG}
printf "# This sshd_config file is designed to be compliant with all STIG settings for\n" >> ${SSH_CONFIG}
printf "# RHEL 6.  These are based on:\n" >> ${SSH_CONFIG}
printf "#\tRed Hat Enterprise Linux 6 Security Technical Implementation Guide\n" >> ${SSH_CONFIG}
printf "#\tVersion 1, Release 13, dated 18 Oct 2016\n" >> ${SSH_CONFIG}
printf "#\n" >> ${SSH_CONFIG}
printf "################################################################################\n" >> ${SSH_CONFIG}
printf "\n" >> ${SSH_CONFIG}
printf "# RHEL-06-000227\tV-38607\n" >> ${SSH_CONFIG}
printf "# The SSH daemon must be configured to use only the SSHv2 protocol\n" >> ${SSH_CONFIG}
printf "Protocol 2\n" >> ${SSH_CONFIG}
printf " \n" >> ${SSH_CONFIG}
printf "# RHEL-06-000230\tV-38608\n" >> ${SSH_CONFIG}
printf "# The SSH daemon must set a timeout interval on idle sessions\n" >> ${SSH_CONFIG}
printf "ClientAliveInterval 900\n" >> ${SSH_CONFIG}
printf "\n" >> ${SSH_CONFIG}
printf "# RHEL-06-000231\tV-38610\n" >> ${SSH_CONFIG}
printf "# The SSH daemon must set a timeout count on idle sessions\n" >> ${SSH_CONFIG}
printf "ClientAliveCountMax 0\n" >> ${SSH_CONFIG}
printf "\n" >> ${SSH_CONFIG}
printf "# RHEL-06-000234\tV-38611\n" >> ${SSH_CONFIG}
printf "# The SSH daemon must ignore .rhosts files\n" >> ${SSH_CONFIG}
printf "IgnoreRhosts yes\n" >> ${SSH_CONFIG}
printf "\n" >> ${SSH_CONFIG}
printf "# RHEL-06-000236\tV-38612\n" >> ${SSH_CONFIG}
printf "# The SSH daemon must not allow host-based authentication\n" >> ${SSH_CONFIG}
printf "HostbasedAuthentication no\n" >> ${SSH_CONFIG}
printf "\n" >> ${SSH_CONFIG}
printf "# RHEL-06-000237\tV-38613\n" >> ${SSH_CONFIG}
printf "# The system must not permit root logins using remote access programs such as ssh\n" >> ${SSH_CONFIG}

# Allow The user to decide on forced-commands
printf "Do you want to allow forced-commands for root over ssh?\n"
printf "Please note - you must POA&M this if you choose this option:\n"
printf "\tEnable forced-commands [Y/N]"
read yn
if [[ $yn =~ [Yy][Ee][Ss]|[Yy] ]];then
  printf "PermitRootLogin forced-commands-only\n" >> ${SSH_CONFIG}
else
  printf "PermitRootLogin no\n" >> ${SSH_CONFIG}
fi

# Continue the remainder of the configs
printf "\n" >> ${SSH_CONFIG}
printf "# RHEL-06-000239\tV-38614\n" >> ${SSH_CONFIG}
printf "# The SSH daemon must not allow authentication using an empty password\n" >> ${SSH_CONFIG}
printf "PermitEmptyPasswords no\n" >> ${SSH_CONFIG}
printf "\n" >> ${SSH_CONFIG}
printf "# RHEL-06-000240\tV-38615\n" >> ${SSH_CONFIG}
printf "# The SSH daemon must be configured with the Department of Defense (DoD) login banner\n" >> ${SSH_CONFIG}
printf "Banner /etc/issue\n" >> ${SSH_CONFIG}
printf "\n" >> ${SSH_CONFIG}
printf "# RHEL-06-000241\tV-38616\n" >> ${SSH_CONFIG}
printf "# The SSH daemon must not permit user environment settings\n" >> ${SSH_CONFIG}
printf "PermitUserEnvironment no\n" >> ${SSH_CONFIG}
printf "\n" >> ${SSH_CONFIG}
printf "# RHEL-06-000243\tV-38617\n" >> ${SSH_CONFIG}
printf "# The SSH daemon must be configured to use only FIPS 140-2 approved ciphers\n" >> ${SSH_CONFIG}
printf "Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc\n" >> ${SSH_CONFIG}
printf "\n" >> ${SSH_CONFIG}
printf "# RHEL-06-000507\tV-38484\n" >> ${SSH_CONFIG}
printf "# The operating system, upon successful logon, must display to the user the date\n" >> ${SSH_CONFIG}
printf "# and time of the last logon or access via ssh\n" >> ${SSH_CONFIG}
printf "PrintLastLog yes\n" >> ${SSH_CONFIG}
printf "\n" >> ${SSH_CONFIG}
printf "################################################################################\n" >> ${SSH_CONFIG}
printf "# End of STIG settings, beginning of custom settings\n" >> ${SSH_CONFIG}
printf "################################################################################\n" >> ${SSH_CONFIG}
printf "\n" >> ${SSH_CONFIG}
printf "HostKey /etc/ssh/ssh_host_rsa_key\n" >> ${SSH_CONFIG}
printf "HostKey /etc/ssh/ssh_host_ecdsa_key\n" >> ${SSH_CONFIG}
printf "HostKey /etc/ssh/ssh_host_ed25519_key\n" >> ${SSH_CONFIG}
printf "AuthorizedKeysFile .ssh/authorized_keys\n" >> ${SSH_CONFIG}
printf "PasswordAuthentication yes\n" >> ${SSH_CONFIG}
printf "ChallengeResponseAuthentication no\n" >> ${SSH_CONFIG}
printf "GSSAPIAuthentication yes\n" >> ${SSH_CONFIG}
printf "GSSAPICleanupCredentials yes\n" >> ${SSH_CONFIG}
printf "UsePAM yes\n" >> ${SSH_CONFIG}
printf "AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES\n" >> ${SSH_CONFIG}
printf "AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT\n" >> ${SSH_CONFIG}
printf "AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE\n" >> ${SSH_CONFIG}
printf "AcceptEnv XMODIFIERS\n" >> ${SSH_CONFIG}
printf "X11Forwarding yes\n" >> ${SSH_CONFIG}
printf "Subsystem     sftp      /usr/libexec/openssh/sftp-server\n" >> ${SSH_CONFIG}
printf "UsePrivilegeSeparation sandbox\n" >> ${SSH_CONFIG}
printf "\n" >> ${SSH_CONFIG}
printf "################################################################################\n" >> ${SSH_CONFIG}
printf "# End of File\n" >> ${SSH_CONFIG}
printf "################################################################################\n" >> ${SSH_CONFIG}

}

################################################################################
# Actually Run the script
################################################################################

if [[ `uname -s` != "Linux" ]];then
  printf "\n\e[0;31mERROR\e[0m\tThis script does not have a valid check for non Linux systems yet!\n"
  end_script
elif [[ -n `uname -r | egrep '.el6.'` ]];then
  if [[ -n `cat /etc/redhat-release | grep 'Red Hat Enterprise Linux Server release 6'` ]];then
    backup_configs
    rhel_6_ssh_configs
    service sshd restart
    end_script
  else
    printf "\n\e[0;31mERROR\e[0m\tThere is a mismatch between the kernel and release versions, please investigate!\n"
    end_script
  fi
elif [[ -n `uname -r | egrep '.el7.'` ]];then
  if [[ -n `cat /etc/redhat-release | grep 'Red Hat Enterprise Linux Server release 7'` ]];then
    backup_configs
    rhel_7_ssh_configs
    systemctl restart sshd
    end_script
  else
    printf "\n\e[0;31mERROR\e[0m\tThere is a mismatch between the kernel and release versions, please investigate!\n"
    end_script
  fi
fi

################################################################################
# End of Script
################################################################################

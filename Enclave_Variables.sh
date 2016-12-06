#!/bin/bash
################################################################################
#
# /Sysadmin/UNIX/scripts/Enclave_variables.sh
#	
# This script is designed to be referenced by other scripts.  It contains the
# specific variables used by the RHEL_STIG_Lockdown scripts.  These should be
# configured prior to running those scripts.
#
################################################################################
#  Beginning of Script
################################################################################

set_variables ()
{
  # General Purpose Variables
  CUR_DATE=$(date +"%Y%m%d")     # YYYYMMDD
  CUR_TIME=$(date +"%H%M%S")     # HHMMSS
  CUR_HOST=`uname -n`            # Current hostname
  ORIG_DIR=`pwd`                 # Saves Original Directory
	
# Start Setting Real Enclave Variables
  REMOTE_LOG_IP="xxx.xxx.xxx.xxx"
  REMOTE_LOG_PROTO=PROTO  # Options: TCP,UDP,RELP
  FW_ORGANIZATION="Organization"
  DOMAIN="domain.com"
  AIDE_EXCLUSION="\!/directory_to_exclude/dir"
  ROOT_MAIL="(email for root's mail)"

	cd /
}

# Ending script function - add cleanup notes here
end_script ()
{
        sleep 1
        cd $ORIG_DIR
        exit
}

# Root UID check
root_uid_check ()
{
	if [[ "$EUID" != "0" ]];then
		printf "\n\e[0;31mERROR\e[0m\tThis script must be run as root\n"
		end_script
	fi
}

################################################################################
# Function - End of Script cleanup
################################################################################

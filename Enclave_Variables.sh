#!/bin/bash
################################################################################
#
# (RHEL_STIG_Baseline)/Enclave_variables.sh
#	
# This script is designed to be referenced by other scripts.  It contains the
# specific variables used by the RHEL_STIG_Lockdown scripts.  These variables
# should be configured prior to running the scripts.
#
# Enclave variables means the specific configurations for your organization or
# network.  This is intended to be as universal as reasonably possible, allowing
# people to modify only one script to customize the collection of baseline
# scripts to their specific requirements.
#
# Future enhancement:  In the future, this script is intended to allow you to
# input the variables by running it instead of manual modification.
#
################################################################################
#
# Created by:        Matthew R. Sawyer
# Last modified by:  Matthew R. Sawyer
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
  REMOTE_LOG_IP="remote_log_ip"        # IP to send syslog messages to
  REMOTE_LOG_PROTO="remote_log_proto"  # Options: TCP,UDP,RELP
  ORG_SHORTNAME="org_shortname"        # Short description of Organization
  DOMAIN="example.com"                 # Primary domain extension
  AIDE_EXCLUSION="aide_exclusion"      # Directories to exclude in aide baseline
  ROOT_MAIL="root_mail"                # Email address to send root's mail to
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

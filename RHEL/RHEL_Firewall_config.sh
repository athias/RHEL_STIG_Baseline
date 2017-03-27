#!/bin/bash
################################################################################
#
# (RHEL_STIG_Baseline)/RHEL/RHEL_Firewall_config.sh
#
# Created by:  Matthew R. Sawyer
#
# This is designed to configure a basic firewall that is STIG compliant.
#
# Important Note:
#   This script will not configure an IPv6 firewall - as in most cases IPv6 is
#   expected to be disabled.
#
################################################################################
#
# This script will correct the following STIG Items:
#	RHEL-06-000113	V-38555
#	RHEL-06-000116	V-38560
#	RHEL-06-000117	V-38512
#	RHEL-06-000120	V-38513
#	RHEL-06-000147	V-38686
#
################################################################################
# Environment Variable
################################################################################

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ ! -f ${BASE_DIR}/../Baseline_Variables.sh ]];then
  printf "\n\e[0;31mERROR:\e[0m\tThe Baseline_Variables.sh script is not available\n\n"
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

rhel_6_firewall_config ()
{

printf "This is not yet configured, TBD\n"
end_script

}

################################################################################
# Function - RHEL 7 Settings
################################################################################

rhel_7_firewall_config ()
{

# Set Variables
FW_TMPL_DIR=${BASE_DIR}/7
FW_SVC_DIR=/etc/firewalld/services
FW_ICMP_DIR=/etc/firewalld/icmptypes
SERVICE_TEMPLATES="firewalld_file.Actifio-Backup-Client.xml firewalld_file.Identity-Management.xml firewalld_file.NetBackup-Client.xml firewalld_file.Oracle-Applications.xml firewalld_file.Oracle-Database.xml firewalld_file.RPC-mountd.xml firewalld_file.SNMP.xml firewalld_file.TSM-Backup-Client.xml firewalld_file.XRDP.xml"
ICMP_TEMPLATES="firewalld_file.timestamp-reply.xml firewalld_file.timestamp-request.xml"

# Verify the Service Templates exists
for CUR_TEMPLATE in ${SERVICE_TEMPLATES};do
  if [[ ! -f ${FW_TMPL_DIR}/${CUR_TEMPLATE} ]];then
    printf "\n\e[0;31mERROR:\e[0m\tSome of the example service templates are missing - aborting!\n\n"
    end_script
  fi
done

# Verify the ICMP Templates exists
for CUR_TEMPLATE in ${ICMP_TEMPLATES};do
  if [[ ! -f ${FW_TMPL_DIR}/${CUR_TEMPLATE} ]];then
    printf "\n\e[0;31mERROR:\e[0m\tSome of the example ICMP templates are missing - aborting!\n\n"
    end_script
  fi
done

# Check the ORG_SHORTNAME Variable
if [[ ${ORG_SHORTNAME} == "org_shortname" ]];then
  printf "\n\e[0;33mNOTICE:\e[0m\tThe Organization\'s Shortname is not set - Using \"GENERIC\" instead.\n\n"
  ORG_SHORTNAME="GENERIC"
fi

# Introduction
printf "===== RHEL 7 - Firewalld configurations =====\n\n"

# Add New Services
printf "\n"
printf "+ Creating New Example Services\n"
/bin/firewall-cmd --permanent --new-service=${ORG_SHORTNAME}-Actifio-Backup-Client
/bin/firewall-cmd --permanent --new-service=${ORG_SHORTNAME}-Identity-Management
/bin/firewall-cmd --permanent --new-service=${ORG_SHORTNAME}-NetBackup-Client
/bin/firewall-cmd --permanent --new-service=${ORG_SHORTNAME}-Oracle-Applications
/bin/firewall-cmd --permanent --new-service=${ORG_SHORTNAME}-Oracle-Database
/bin/firewall-cmd --permanent --new-service=${ORG_SHORTNAME}-RPC-mountd
/bin/firewall-cmd --permanent --new-service=${ORG_SHORTNAME}-SNMP
/bin/firewall-cmd --permanent --new-service=${ORG_SHORTNAME}-TSM-Backup-Client
/bin/firewall-cmd --permanent --new-service=${ORG_SHORTNAME}-XRDP

# Add New ICMP Types
printf "+ Creating New ICMP types\n"
/bin/firewall-cmd --permanent --new-icmptype=timestamp-reply
/bin/firewall-cmd --permanent --new-icmptype=timestamp-request

# Add New Zone
printf "+ Creating new Zone based on Organization\n"
/bin/firewall-cmd --permanent --new-zone=${ORG_SHORTNAME}

# Configure New Zone to Drop
printf "+ Setting default target of new Zone to DROP\n"
/bin/firewall-cmd --permanent --zone=${ORG_SHORTNAME} --set-target=DROP

# Copy Service Templates
printf "+ Copying Templates for Example Services\n"
for CUR_TEMPLATE in ${SERVICE_TEMPLATES};do
  SERVICE_XML=`echo ${CUR_TEMPLATE} | sed "s/firewalld_file\./${ORG_SHORTNAME}-/"`
  /bin/cp -f ${FW_TMPL_DIR}/${CUR_TEMPLATE} ${FW_SVC_DIR}/${SERVICE_XML}
done

# Copy ICMP Templates
printf "+ Copying Templates for Example ICMP types\n"
for CUR_TEMPLATE in ${ICMP_TEMPLATES};do
  ICMP_XML=`echo ${CUR_TEMPLATE} | sed "s/firewalld_file\.//"`
  /bin/cp -f ${FW_TMPL_DIR}/${CUR_TEMPLATE} ${FW_ICMP_DIR}/${ICMP_XML}
done

# Reload firewall to apply configuration changes
printf "+ Reloading the Firewall to update settings\n"
/bin/firewall-cmd --reload

# Set default Zone
printf "+ Setting the default zone to ${ORG_SHORTNAME}\n"
/bin/firewall-cmd --set-default-zone=${ORG_SHORTNAME}

# Add required default Firewall Rules
printf "+ Enabling SSH connections through the firewall\n"
/bin/firewall-cmd --permanent --zone=${ORG_SHORTNAME} --add-service=ssh

# Add required icmptypes
printf "+ Configuring  SSH connections through the firewall\n"
/bin/firewall-cmd --permanent --zone=${ORG_SHORTNAME} --add-icmp-block=timestamp-reply
/bin/firewall-cmd --permanent --zone=${ORG_SHORTNAME} --add-icmp-block=timestamp-request

# Allow in ICMP
printf "+ Enabling ICMP requests for your designated subnet\n"
if [[ ${FW_ICMP_SUBNET} == "fw_icmp_subnet" ]];then
  printf "\n\e[0;33mNOTICE:\e[0m\tThe Firewall Subnet is not set - ICMP requests must be configured manually.\n\n"
else
  /bin/firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p icmp -s ${FW_ICMP_SUBNET} -j ACCEPT
fi

# Add Rich Rules
printf "+ Configuring the firewall for rate limiting\n"
/bin/firewall-cmd --permanent --zone=${ORG_SHORTNAME} --add-rich-rule='rule family="ipv4" source address="0.0.0.0/0" destination address="0.0.0.0/0" protocol value="tcp" accept limit value="25/m"'

# Reload firewall to apply configuration changes
printf "+ Reloading the firewall to activate changes\n"
/bin/firewall-cmd --reload

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
    rhel_6_firewall_config
    end_script
  else
    printf "\n\e[0;31mERROR\e[0m\tThere is a mismatch between the kernel and release versions, please investigate!\n"
    end_script
  fi
elif [[ -n `uname -r | egrep '.el7.'` ]];then
  if [[ -n `cat /etc/redhat-release | grep 'Red Hat Enterprise Linux Server release 7'` ]];then
    rhel_7_firewall_config
    end_script
  else
    printf "\n\e[0;31mERROR\e[0m\tThere is a mismatch between the kernel and release versions, please investigate!\n"
    end_script
  fi
fi

################################################################################
# End of Script
################################################################################

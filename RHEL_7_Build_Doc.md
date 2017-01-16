# RHEL 7 Build Document

## Table of Contents
1. Assumptions
2. Pre-requisite Validation
3. Recommended Configurations
4. Base OS Installation
5. Post Installation Configurations

## Assumptions

* NFS services are used for home directories
  * If NFS home directories are not used, be careful to read the related notes
* Core CPU (1@2Ghz) and RAM (4GB) requirements met
* A non-root local account for administration and emergencies is required
* All Variables within 'Enclave_Variables.sh' have been appropriately set
  * Please review the document on Configuring Enclave Variables
* The Baseline scripts are available, locally or through an NFS share
* The system you are building is a VM (not physical) of RHEL Server
* For VMWare VM's an ISO for RHEL 7 is available on a datastore

## Prerequisites

* Approval to Build and Test your server (VM)
* Approval for capacity of server
* System Information Reserved/Documented
  * Hostname
  * IP Address
  * Gateway
  * Subnet Mask
  * DNS Forward Lookup entry configured
  * DNS Reverse Lookup entry configured
  * Relative LDAP entries created

## Recommended Configurations

### Core Configurations

 * CPU - minumum 2CPU for base OS
   * Add more as required for specific application
 * RAM - minimum 4GB RAM for base OS
   * Add more as required for specific application
 * HDD1 - Primary HDD should be 50GB
   * For systems requiring more than 8GB swap, recommend adding extra swap space to primary HDD
     * example 1: 16GB swap would make a 58 GB HDD1
     * example 2: 16GB swap would make a 66 GB HDD1
   * Additional Space for applications should be on HDD2
     * For VM's this allows you to separate the core OS from the application
     * This prevents the OS from crashing (for troubleshooting purposes) if the application fills the HDD

### VMWare Specific Configurations

#### Virtual Hardware

Section | Setting | Value
--------|---------|------
VM Version | \* | Upgrade to the Latest Version
CPU | CPU Hot Plug | Enable
Memory | Memory Hot Plug | Enable
Network Adapter | Status | Connect At Power On
CD/DVD Drive | \* | Datastore ISO File (connected)
CD/DVD Drive | Status | Connected at Power On
CD/DVD Drive | CD/DVD Media | (Locate RHEL 7 Installation DVD ISO)
Floppy Drive | \* | Remove Floppy Drive
Video Card | \* | Auto-Detect Settings
Video Card | Enable 3D Support | Checked

#### VM Options

Section | Setting | Value
--------|---------|------
General Options | Guest OS | Linux
General Options | Guest OS Version | Red Hat Enterprise Linux 7 (64-bit)
VMware Remote Console Options | Max # of Sessions | Limit, 1
Boot Options | Boot Delay | 10000

## Base OS Installation

### Core Configurations

* Power on VM
  * VM Should automatically boot to RHEL 7
    * Verify Pre-requisites and VM Configuration if this does not happen

* At the 'Welcome to Red Hat Enterprise Linux' screen, Click Continue

* Under 'system' > click on 'Network & Hostname'
  * Click the on/off slide button for the ethernet connection
  * Change the default hostname to the FQDN of your system
  * Click Configure
    * Under General > Check - 'Automatically connect to this network when it is available'
    * Under IPv6 Settings > Select Method: Ignore
    * Under IPv4 Settings > Select Method: Manual
    * Under IPv4 Settings > Click Add Under Addresses
    * Under IPv4 Settings > Fill in the Address / Netmask / Gateway
    * Under IPv4 Settings > Fill in the DNS servers (separated by a comma)
    * Under IPv4 Settings > Fill in the search domain
    * Click Save
  * Click Done

* Under system > click on 'KDUMP'
  * (OPTIONAL) uncheck 'Enable kdump'  
> NOTE: For most systems, kdump is not likely required.  It may be required for special purpose or physical servers.  It is most commonly used in application development systems, specifically for testing purposes.

* Under Software > click on 'Software Selection'
  * Under 'Base Environment' ensure 'minimal' is selected
  * Click Done

* Under Localization > Click 'Date & Time'
  * Under 'Region' select 'Etc'
  * Under 'City' select 'Coordinated Universal Time'
  * Under 'Network Time' change the switch to 'on'
  * Under 'Network Time' click the gears to configure NTP servers
    * Uncheck all 'rhel.pool.ntp' options
    * Add the NTP server for your specific environment by clicking the '+'
    * Repeat for each additional NTP server for your enviroment
    * Click 'OK'
  * Click Done

### Partitioning

* Under system > click on 'Installation Destination'
  * Ensure the 50GiB disk is selected with a checkmark
  * Under Other Storage Options select 'I will configure partitioning'
    * Click Done

* Click on the 'click here to create them automatically' link

* Under any listed partition click 'Modify...' Under 'Volume Group'
  * Change the name to 'vg_rhel7'
  * Change the 'Size Policy' to 'As large as possible'
  * Click Ok

* Configure partitions based on the recommendations in Partition Table below

Mountpoint | Size | Volume Group | Name
-----------|------|--------------|------
/boot | 1024 MiB | N/A - sda1 | N/A
/ | \* | vg_rhel7 | lv_root
[swap] | 8192 MiB | vg_rhel7 | lv_swap
/local_home | 2048 MiB | vg_rhel7 | lv_local_home
/tmp | 5120 MiB | vg_rhel7 | lv_tmp
/var | 15 GiB | vg_rhel7 | lv_var
/var/log | 2048 MiB | vg_rhel7 | lv_var_log
/var/log/audit | 2048 MiB | vg_rhel7 | lv_var_log_audit

> NOTE: The asterisk at the size of the root partition represents the usage of any remaining space.  In the configuration above, that leaves 15 GiB for root.  
> NOTE: For systems with more than 50GB disk space, a '/home' partition will be created automatically.  For systems with less than 50GB disk space, all extra space will be added to the root '/' partition.  

* Click Done

* Click 'Accept Changes'

### Installation Configuration

* Click 'Begin Installation'

* Under 'User Settings' click on 'Root Password'
  * Input the root password under 'Root Password'
  * Input the root password again under 'Confirm'
  * Click Done

* Under 'User Settings' click on 'User Creation'
  * Under 'Full Name' input 'Local Administrator'
  * Under 'User name' change it to 'local_admin'
  * Check the box next to 'Make this user administrator'
  * Input the user password under 'Password'
  * Input the user password again under 'Confirm Password'
    * Click the box 'Advanced'
    * Change the 'Home directory' to '/local_home/local_admin'
    * Check the box next to 'Specify a user ID manually'
    * Ensure the number next to 'Specify a user ID manually' is set to '1000'
    * Check the box next to 'Specify a group ID manually'
    * Ensure the number next to 'Specify a user ID manually' is set to '1000'
    * click 'Save Changes'
  * Click Done

* Wait for the Installation process to complete

> NOTE: It will state "Red Hat Enterprise Linux is now successfully installed and ready for you to use!"

* Click 'Reboot'

## Post Installation Configurations

* Log into the system and gain root access

### Reconfigure Network Devices  
> NOTE: RHEL 7 uses hardware related naming conventions by default, and the configuration below disables that.  When system hardware is modified, especially in the case of VM hardware versions it can change the names of network interfaces.  This can cause your network to stop working, and prevent access from certain applications - notably Oracle RAC Databases.  
> NOTE: If the system has more than one interface configured, these steps will fail.  Please do multiple interfaces manually.

* Modify The default grub Configuration  
`# sed -i 's/rhgb quiet\"$/rhgb quiet net.ifnames\=0 biosdevnames\=0\"/' /etc/default/grub`

* Make the configuration persistent
  * For Systems with BIOS:  
  `# grub2-mkconfig -o /boot/grub2/grub.cfg`  
  * For Systems with UEFI:  
  `# grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg`  

* Identify the old Interface  
`# OLD_NET=$(ls -l /etc/sysconfig/network-scripts/ifcfg-* | egrep -v "*.old$|ifcfg-lo$" | awk '{print $9}')`

* Rename the old interface to eth0  
`# NEW_NET=/etc/sysconfig/network-scripts/ifcfg-eth0`  
`# mv ${OLD_NET} ${NEW_NET}`  

* Modify the new Network Interface Configuration  
`# OLD_NET_NAME=$(echo ${OLD_NET} | sed 's/.*ifcfg-//')`  
`# sed -i "s/${OLD_NET_NAME}/eth0/g" ${NEW_NET}`  
`# sed -i '/IPV6_AUTOCONF/d' ${NEW_NET}`  
`# sed -i '/IPV6_DEFROUTE/d' ${NEW_NET}`  
`# sed -i '/IPV6_PEERDNS/d' ${NEW_NET}`  
`# sed -i '/IPV6_PEERROUTES/d' ${NEW_NET}`   
`# sed -i '/IPV6_FAILURE_FATAL/d' ${NEW_NET}`  
`# sed -i '/UUID=/d' ${NEW_NET}`  

* Reboot the system to ensure the settings are persistent  
`# systemctl reboot`  
> NOTE:  The system MUST be rebooted at this time.  If it is not rebooted, future configurations may cause the system to fail to boot.






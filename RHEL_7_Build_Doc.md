RHEL 7 Server Build

-----
Assumptions
-----

1. NFS services are used for home directories
2. Core CPU (1@2Ghz) and RAM (4GB) requirements met
3. A non-root local account for emergencies is required
4. All Variables within 'Enclave_Variables.sh' have been appropriately set

-----
Prerequisites
-----

Hostname
IP Address
Gateway
Subnet Mask
Idetification of non-root local account
A Designated e-mail address for root mail
DNS entries correct
	NOTE: Verify both the forward and reverse lookups are correct
OS Disk Size (50GB)
	Note: For Systems requiring > 8GB of swap (i.e. Database Servers), Add (RAM-8GB) to the OS disk to account for the extra swap space needed
	Note: For Systems requiring additional local home directory storage (i.e. Database Servers), add 5GB to the OS disk per local account

-----
Booting from the DVD
-----

+ Install Red Hat Enterprise Linux

+ At the 'Welcome to Red Hat Enterprise Linux' screen, click Continue

+ Under system > click on 'Network & Hostname'
	- Click the on/off button for the ethernet connection
	- Change the hostname to the FQDN
	- Click Configure
		# Under General
			~ Check - Automatically connect to this network when it is available
		# Under IPv6 Settings
			~ Select Method: Ignore
		# Under IPv4 Settings
			~ Select Method: Manual
			~ Click Add under Addresses
			~ Fill in the Address / Netmask / Gateway
			~ Fill in the DNS servers (separated by a comma)
			~ Fill in the search domain
		# Click Save
	- Click Done
+ Under system > click on 'KDUMP'
	- (OPTIONAL) uncheck 'Enable kdump'
	- NOTE: In most situations, kdump is not necessary.  Generally the exceptions would include special development platforms, or bleeding edge test systems.
	- Click Done
+ Under system > click on 'Installation Destination'
	- Ensure the 50GiB disk is selected with a checkmark
	- Under Other Storage Options select 'I will configure partitioning'
	- Click Done
+ Manual Partitioning (Automatic when you clicked done previously)
	- Click on the 'click here to create them automatically' link
		# Select the '/' partition
			~ Change 'Desired Capacity' to 10 GiB
			~ Change the 'Name' to 'lv_root'
			~ Click 'Update Settings'
			~ Under the 'Volume Group' click 'Modify...'
				@ Change the name to 'vg_rhel7'
				@ Change the 'Size policy' to 'As large as possible'
				@ Click Save
		# Select the 'swap' partition
			~ For systems with less than 16GB RAM, Change the 'Desired Capacity' to 4096 MiB
			~ For systems with 16GB RAM or more, Change the 'Desired Capacity' to 8192 MiB
			~ Change the 'Name' to lv_swap
			~ Click 'Update Settings'
		# Click the '+' button to add a new partition
			~ NOTE:	For OS Disks >50GB, the setup will automatically create a '/home' - In this event, change '/home' to '/local_home', size to '2048 MiB' and change the Name to 'lv_local_home'
			~ Under 'Mount Point' enter '/local_home'
			~ Under 'Desired Capacity' enter '2048 MiB'
			~ Click 'Add Mount Point'
			~ Change the 'Name' to 'lv_local_home'
			~ Click 'Update Settings'
		# Click the '+' button to add a new partition
			~ Under 'Mount Point' enter '/tmp'
			~ Under 'Desired Capacity' enter '5120 MiB'
			~ Click 'Add Mount Point'
			~ Change the 'Name' to 'lv_tmp'
			~ Click 'Update Settings'
		# Click the '+' button to add a new partition
			~ Under 'Mount Point' enter '/var'
			~ Under 'Desired Capacity' enter '15 GiB'
			~ Click 'Add Mount Point'
			~ Change the 'Name' to 'lv_var'
			~ Click 'Update Settings'
		# Click the '+' button to add a new partition
			~ Under 'Mount Point' enter '/var/log'
			~ Under 'Desired Capacity' enter '2048 MiB'
			~ Click 'Add Mount Point'
			~ Change the 'Name' to 'lv_var_log'
			~ Click 'Update Settings'
		# Click the '+' button to add a new partition
			~ Under 'Mount Point' enter '/var/log/audit'
			~ Under 'Desired Capacity' enter '2048 MiB'
			~ Click 'Add Mount Point'
			~ Change the 'Name' to 'lv_var_log_audit'
			~ Click 'Update Settings'
		# Note: Only add the following if a local home directory is required - this example is for database
			~ Click the '+' button to add a new partition
				@ Under 'Mount Point' enter '/export/home/oracle'
				@ Under 'Desired Capacity' enter '5120 MiB'
				@ Click 'Add Mount Point'
				@ Change the 'Name' to 'lv_oracle_home'
				@ Click 'Update Settings'
		# Select the '/' partition
			~ Identify the remaining space available (listed under the Volume Group), and add 10GB to it, then round up to the nearest GB.
			~ Example:	6.56 GB remaining, +10GB, rounded up = 17 GB
			~ Change 'Desired Capacity' to the combined value identified above
			~ NOTE:		If you allocate over the amount of space available, it will automatically choose all remaining space.
	- Click Done
	- Click 'Accept Changes'
+ Under Softare > click on 'Software Selection'
	- Under 'Base Environment' select 'Server with GUI'
		# NOTE:	There are multiple options you could do here.  This is a general purpose server which is why 'Server with GUI' is selected.  Choose the configuration that best suits your environment.
	- Click Done
+ Under Localization > Click 'Date & Time'
	- Under 'Region' select 'Etc'
	- Under 'City' select 'Coordinated Universal Time'
	- Under 'Network Time' change the switch to 'on'
	- Under 'Network Time' click the gears to configure NTP servers
		# Uncheck all 'rhel.pool.ntp' options
		# Add the default gateway by inputting the IP address in the top bar and clicking the '+'
		# Repeat for the '.2' and '.3' IP's in the same manner the default gateway was added
		# Click 'OK'
	- Click Done
+ Click 'Begin Installation'

+ Under 'User Settings' click on 'Root Password'
	- Input the root password under 'Root Password'
	- Input the root password again under 'Confirm'
	- Click Done
+ Under 'User Settings' click on 'User Creation'
	- Under 'Full Name' input 'Local Administrator'
	- Under 'User name' change it to 'local_admin'
	- Check the box next to 'Make this user administrator'
	- Input the user password under 'Password'
	- Input the user password again under 'Confirm Password'
	- Click the box 'Advanced'
		# Change the 'Home directory' to '/local_home/local_admin'
		# Check the box next to 'Specify a user ID manually'
		# Change the number next to 'Specify a user ID manually' to '1000'
		# Check the box next to 'Specify a group ID manually'
		# Change the number next to 'Specify a group ID manually' to '1000'
		# click 'Save Changes'
	- Click Done

+ Wait for the Installation process to complete
	- It will state "Red Hat Enterprise Linux is now successfully installed and ready for you to use!"
+ Click 'Reboot'

+ After rebooting the 'Initial Setup' menu will appear
	- NOTE: Sometimes the GUI license information will not appear, below are the command line only steps
		# type 1 <return>
		# type 2 <return>
		# type c <return>
		# type c <return>
	- Under Licensing click 'License information'
		# Check the box next to 'I accept the license agreement'
		# Click Done
	- Click 'Finish Configuration'

+ The GUI login will appear - Log in as 'Local Administrator'
+ Click Next at the welcome screen
+ Click Next again
+ Click Skip
+ Click 'Start using Red Hat Enterprise Linux Server'
+ Close the 'Getting Started' window that appears
+ Right Click on the desktop and select 'Open Terminal'
+ Gain Root access (# sudo -i)
+ Begin configuration

-----
Bashrc Modification
-----

# vim /root/.bashrc
	(append)
	# Root Specific Configurations
	HISTSIZE=9999
	PS1="[\[\e[0;31m\]\u\[\e[0m\]]@[\[\e[0;36m\]\h\[\e[0m\]]:[\[\e[0;33m\]\w\[\e[0m\]] \\$ "
	(save & quit)
# vim /local_home/admin_local/.bashrc
	(append)
	# User Specific Configurations
	HISTSIZE=9999
	PS1="[\[\e[0;31m\]\u\[\e[0m\]]@[\[\e[0;36m\]\h\[\e[0m\]]:[\[\e[0;33m\]\w\[\e[0m\]] \\$ "
	(save & quit)

-----
Modify /etc/fstab
-----

NOTE:	The purpose is to ensure the /etc/fstab is easily readable and complete
Standards:	Header Exists
		Tab Separated
		Sections Start at same column
# vim /etc/fstab
	(Add a header)
	# Device	Mountpoint	FStype		Options			FSDump/FSCK
	(Add tmpfs directories)
	(NOTE: the size=#M should be 1/2 RAM, in this example the system has 8GB of RAM)
	devtmpfs	/dev		devtmpfs	defaults,size=4096M	0 0
	tmpfs		/dev/shm	tmpfs		defaults,size=4096M	0 0
	tmpfs		/run		tmpfs		defaults,size=4096M	0 0
	tmpfs		/sys/fs/cgroup	tmpfs		defaults,size=4096M	0 0
	(modify)
	Change the /tmp line to have options of 'defaults,noexec'
	(modify)
	Change the '/' line to have FSDUMP/FSCK options of '1 1'
	(modify)
	Change non-root LVM partitions (except swap) to have FSDUMP/FSCK options of '1 2'
	(save & quit)

***** Example *****
#
# /etc/fstab
#
# Device                                        Mountpoint      FStype          Options                 FSDump/FSCK
/dev/mapper/vg_rhel7-lv_root                    /               xfs             defaults                1 1
UUID=4a0896c0-b566-4a56-bcb4-485c7189eeb0       /boot           xfs             defaults                0 0
/dev/mapper/vg_rhel7-lv_local_home              /local_home     xfs             defaults                1 2
/dev/mapper/vg_rhel7-lv_tmp                     /tmp            xfs             defaults,noexec         1 2
/dev/mapper/vg_rhel7-lv_var                     /var            xfs             defaults                1 2
/dev/mapper/vg_rhel7-lv_var_log                 /var/log        xfs             defaults                1 2
/dev/mapper/vg_rhel7-lv_var_log_audit           /var/log/audit  xfs             defaults                1 2
/dev/mapper/vg_rhel7-lv_swap                    swap            swap            defaults                0 0
devtmpfs                                        /dev            devtmpfs        defaults,size=4096M     0 0
tmpfs                                           /dev/shm        tmpfs           defaults,size=4096M     0 0
tmpfs                                           /run            tmpfs           defaults,size=4096M     0 0
tmpfs                                           /sys/fs/cgroup  tmpfs           defaults,size=4096M     0 0
***** Example *****

-----
Connect to Sysadmin Share
-----

The sytem administration share is where all of the configuration scripts are contained.  All of these scripts are assumed to be located in the '/Sysadmin/baseline' directory.

mkdir /Sysadmin
mount -o ver=3,rw,nosuid,nodev (nfs_server):/(path_to_sysadmin) /Sysadmin

-----
Update Repository
-----

# rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

-----
Remove virtual bridge
-----

# virsh net-destroy default
# virsh net-undefine default

-----
Remove unnecessary packages
-----

# yum -y remove rhn*
# yum -y remove abrt*
# yum -y remove orca
# yum -y remove gnome-weather
# yum -y remove gnome-video-effects
# yum -y remove gnome-packagekit-updater
# yum -y remove gnome-software
# yum -y remove empathy
# yum -y remove totem
# yum -y remove icedtea-web
# yum -y remove firefox
# yum -y remove qemu-kvm
# yum -y remove anaconda-user-help
# yum -y remove libvirt*
# yum -y remove libgovirt
# yum -y remove '*qemu*'

-----
Install additional required packages
-----

# yum -y install aide
# yum -y install screen

Optional:
# yum -y install sssd
# yum -y install autofs
# yum -y install ksh
# yum -y install zsh

-----
Selinux Modifications
-----

# semanage fcontext -a -t home_root_t '/local_home'
# semanage fcontext -a -t user_home_dir_t '/local_home/local_admin'
# semanage fcontext -a -t user_home_t '/local_home/local_admin(/.*)?'

# restorecon -RFvv /local_home

# setsebool -P use_nfs_home_dirs 1

-----
Modify Network Interface Names
-----

# vim /etc/default/grub
	(append to the 'GRUB_CMDLINE_LINUX', within the quotes)
	net.ifnames=0 biosdevnames=0
	(save & quit)

# grub2-mkconfig -o /boot/grub2/grub.cfg

Rename the existing Interface to eth0
	# mv /etc/sysconfig/network-scripts/ifcfg-en* /etc/sysconfig/network-scripts/ifcfg-eth0
	NOTE: The above command assumes you only have one interface.  If you have multiple, perform each individually and substitute for eth1, eth2, etc.

# vim /etc/sysconfig/network-scripts/ifcfg-eth0
	(modify, change instances of eno16700#### to eth0)
	NAME=eth0
	DEVICE=eth0
	(Remove the following Lines:)
		IPV6_AUTOCONF=yes
		IPV6_DEFROUTE=yes
		IPV6_PEERDNS=yes
		IPV6_PEERROUTES=yes
		IPV6_FAILURE_FATAL=no
	(save & quit)

Reboot the system to ensure configurations are persistent
	# init 6

-----
Non-STIG specific Configurations
-----

(OPTIONAL) NOTE: For most architectures, rngd.service will fail to start - this will correct that by running it through /dev/urandom
# sed -i 's/\/sbin\/rngd \-f/\/sbin\/rngd \-f \-r \/dev\/urandom \-o \/dev\/random/' /usr/lib/systemd/system/rngd.service
# systemctl daemon-reload
# systemctl restart rngd.service

(OPTIONAL) NOTE: If you use custom CA certificates for your primary communications, your firewall personnel may block outbound DNSSEC queries.  This will stop those requests.
# systemctl stop unbound-anchor.timer
# systemctl disable unbound-anchor.timer

-----
STIG remediations
-----

# sed -i '/vc\/[0-9]/d' /etc/securetty

# printf "# STIG ID RHEL-06-000069\nSINGLE=/sbin/sulogin\n# STIG ID RHEL-06-000070\nPROMPT=no\n" >> /etc/sysconfig/init

# sed -i '/\[global\]/a client signing = mandatory' /etc/samba/smb.conf

# rpm --setperms audit

# systemctl mask ctrl-alt-del.target

# sed -i '/End of file/d' /etc/security/limits.conf
# printf "*\t\thard\tcore\t\t0\n*\t\thard\tmaxlogins\t10\n" >> /etc/security/limits.conf

# sed -i 's/INACTIVE\=\-1/INACTIVE\=35/' /etc/default/useradd

# sed -e '/^com2sec/ s/^#*/#/' -i /etc/snmp/snmpd.conf
# sed -e '/^group.*\ v1\ .*/ s/^#*/#/' -i /etc/snmp/snmpd.conf
# sed -e '/^group.*\ v2c\ .*/ s/^#*/#/' -i /etc/snmp/snmpd.conf
# systemctl restart snmpd

# sed -i 's/umask 002/umask 077/' /etc/bashrc /etc/csh.cshrc /etc/profile
# sed -i 's/umask 022/umask 077/' /etc/bashrc /etc/csh.cshrc /etc/profile

# sed -i 's/active \= no/active \= yes/' /etc/audisp/plugins.d/syslog.conf

+ Set the appropriate mail forwarding
	# ROOT_MAIL=(Designated e-mail for root's mail)
	# echo "root: ${ROOT_MAIL}@mail.mil" >> /etc/aliases
	# newaliases

# echo "chmod 0600 /var/log/boot.log" >> /etc/rc.d/rc.local
# chmod u+x /etc/rc.d/rc.local

# systemctl set-default multi-user.target

-----
Start real STIG remediations
-----

# Run Firewall Configuration script
	TBD

# Run all configuration scripts
	TBD

-----
Transition Configurations
-----

Set the Grub Password

Set the Root Password

Perform the Aide Installation

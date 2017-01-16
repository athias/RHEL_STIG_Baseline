# RHEL 7 Build Document

## Table of Contents
1. Assumptions
2. Pre-requisite Validation
3. Base OS Build from DvD

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

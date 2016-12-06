# RHEL_STIG_Lockdown

Welcome to the Red Hat Enterprise Linux (RHEL) Secure Technical Implementation
Guide (STIG) Lockdown repository.  This is a series of scripts designed to
augment a properly designed build document.  They perform a combintion of system
lockdowns according to the STIG and additional security and optimization best
practices.  It is assumed that some STIG settings are performed during the
initial server installation.

## RHEL Build Document

This is an example build document that provides a detailed set of instructions
for configuring a general purpose server.  This is assumed to be a Virtual
Machine (VM) of some kind.  Additional notes may be provided for specific server
purposes.  These guidelines should be tailored to your specific operational
environment based on needs and capabilities.  Build Documents are available for
RHEL 6 and RHEL 7.

## Enclave Variables

The Enclave Varibles is designed to allow these scripts to be easily configured
for multiple environments.  There are a limited number of enclave specific
configurations, and this is an attempt to identify as many as possible.  If used
correctly, this combined with the build scripts and document can almost
completely automate building a new system.  Proper care and feeding of these
variables is important.

## RHEL Scripts

Each script is designed to be kernel independent.  They will each perform an
architecture check, and perform the appropriate configurations.  If you attempt
to run the scripts on a non RHEL platform, they are coded to fail in most cases.
The scripts used the base templates provided within the sub directories matching
the applicable major release version for RHEL.

## Important notes

* There are currently no scripts specific to non x86_64 architecture
* Not all optional settings will be clearly idenified
* This is a guideline, not a prescription - use at your own risk
* With great power comes great responsibility!

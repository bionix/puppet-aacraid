# Puppet module 'aacraid'
#
# This puppet module manages the Debian kernel driver 'aacraid' for Adaptec RAID
# controller.
# The default Debian wheezy kernel has an outdated kernel version for Adaptec
# RAID controller series 6 / 7 / 8 and higher.
#
# The puppet module installs the aacraid dkms-based sources and installs via
# dkms the newest aacraid version.
# Add the kernel module to the /etc/modules and /etc/initramfs-tools/modules and
# update all kernel initramfs files.
#
# Class aacraid::uninstall  -> uninstall all changes
#
# Class aacraid::install    -> install all stuff
#
# Class aacraid::initramfs  -> add aacraid module to the initramfs files

class aacraid (
  $ensure               = 'present',
  $initramfs_update     = true
) {
  if ($::architecture == amd64) and ($::operatingsystem == Debian) {
    case $ensure {
      absent:   { include aacraid::uninstall }
      present:  { include aacraid::install }
      default:  { notice "Wrong value in variable ensure -> ${ensure} !" }
    }
    if $initramfs_update == true {
      include aacraid::initramfs
    }
  } else {
    notify { "Unsupported architecture and/or OS: $::architecture / $::operatingsystem": }
  }
}
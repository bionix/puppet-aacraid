# Class aacraid::initramfs
#
class aacraid::initramfs {
  exec { 'etc_modules':
    command => 'echo aacraid >> /etc/modules',
    unless  => 'grep -qFx aacraid /etc/modules'i
    notify  => Exec['update_initramfs_all']
  }
  exec { 'etc_initramfstools_modules':
    command => 'echo aacraid >> /etc/initramfs-tools/modules',
    unless  => 'grep -qFx aacraid /etc/initramfs-tools/modules',
    notify  => Exec['update_initramfs_all']
  }
  exec { 'update_initramfs_all':
    command     => 'update-initramfs -k all -u',
    refreshonly => true
  }
}
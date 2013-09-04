# Class aacraid::install
class aacraid::uninstall inherits aacraid::params {
  $packages = [ 'dkms', 'build-essential', 'aacraid' ]
  package { $packages:
    ensure => absent
  }

  file { "/usr/src/${aacraid_version}", "/usr/src/${aacraid_version}/aacraid_dkms.deb":
    ensure => absent
  }
}
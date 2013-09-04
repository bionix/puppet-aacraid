# Class aacraid::install
class aacraid::install inherits aacraid::params {
  $packages = [ 'dkms', 'build-essential' ]
  package { $packages:
    ensure => 'present'
  }

  file { [ '/usr', '/usr/src', "/usr/src/${aacraid_version}" ]:
    ensure => 'directory'
  }

  file { "/usr/src/${aacraid_version}/aacraid_dkms.deb":
    ensure  => 'present',
    source  => "puppet:///modules/aacraid/$::architecture/${aacraid_version}/aacraid_dkms.deb",
    owner   => 'root',
    group   => 'root',
    mode    => '0550'
  }

  package { 'aacraid':
    ensure    => 'present',
    provider  => 'dpkg',
    source    => "/usr/src/${aacraid_version}/aacraid_dkms.deb",
    require   => File["/usr/src/${aacraid_version}/aacraid_dkms.deb"]
  }

  File['/usr'] ~> File['/usr/src'] ~> File["/usr/src/${aacraid_version}"] ~> File["/usr/src/${aacraid_version}/aacraid_dkms.deb"]

  exec { 'aacraid_dkms_add':
    command       => "dkms add -m aacraid -v ${aacraid_version}",
    unless        => "dkms status | grep aacraid | grep ${aacraid_version} | grep -iE '(build|installed|add)'",
    require       => Package['aacraid']
  }
  exec { 'aacraid_dkms_build':
    command       => "dkms build -m aacraid -v ${aacraid_version}",
    unless        => "dkms status | grep aacraid | grep ${aacraid_version} | grep -iE '(build|installed)'"
  }
  exec { 'aacraid_dkms_install':
    command       => "dkms install -m aacraid -v ${aacraid_version}",
    unless        => "dkms status | grep aacraid | grep ${aacraid_version} | grep -iE installed"
  }

  Exec['aacraid_dkms_add'] ~> Exec['aacraid_dkms_build'] ~> Exec['aacraid_dkms_install']

}
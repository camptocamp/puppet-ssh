# See README.md for details.
class ssh {

  $package_name = $::osfamily ? {
    'Debian' => 'ssh',
    'RedHat' => 'openssh',
  }

  package {'ssh':
    ensure => present,
    name   => $package_name,
  }

  $service_name = $::osfamily ? {
    'Debian' => 'ssh',
    'RedHat' => 'sshd',
  }

  service {'ssh':
    ensure     => running,
    name       => $service_name,
    hasrestart => true,
    pattern    => '/usr/sbin/sshd',
    require    => Package['ssh'],
  }

  file {'/etc/ssh/ssh_known_hosts':
    ensure => file,
    mode   => '0644',
    owner  => 'root',
  }

}

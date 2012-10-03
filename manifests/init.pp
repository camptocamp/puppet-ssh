class ssh {

  package {'ssh':
    name => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'ssh',
      /RedHat|CentOS/ => 'openssh',
    },
    ensure => present,
  }

  service {'ssh':
    name => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'ssh',
      /RedHat|CentOS/ => 'sshd',
    },
    ensure     => running,
    hasrestart => true,
    pattern    => '/usr/sbin/sshd',
    require    => Package['ssh'],
  }

  file {'/etc/ssh/ssh_known_hosts':
    ensure => present,
    mode   => '0644',
    owner  => 'root',
  }

}

# == Define: ssh::sftp::user
#
# Setup Linux user accounts restricted to using SFTP only
#
# === Parameters
#
# [*namevar*]
#   The account name
#
# [*ssh_key*]
#   The authorized key; generally a long string of hex digits
#
# [*ssh_type*]
#   The encryption type used. See *ssh_authorized_type/type* for more details
#
# [*ssh_options*]
#   Key options, see sshd(8) for possible values
#
# [*present*]
#   Define if this account is present or absent
#
# [*home*]
#   The home directory of the user
#
# [*basedir*]
#   This directory will be used to store files
#
# [*basedir_mode*]
#   The desired permissions for the base directory
#
# [*group*]
#   The restricted sftp group name. Must be declared outside this definition.
#
# === Examples
#
#   ssh::sftp::user { 'namevar':
#     ssh_key => 'AAAAB3NzaC1yc...',
#   }
#
# === Authors
#
# Mathieu Bornoz <mathieu.bornoz@camptocamp.com>
#
define ssh::sftp::user (
  $ssh_key,
  $ssh_type     = 'ssh-rsa',
  $ssh_options  = [],
  $ensure       = 'present',
  $home         = false,
  $basedir      = 'uploads',
  $basedir_mode = '2775',
  $group        = 'sftponly'
) {

  $user_home = $home ? {
    false   => "/home/${name}",
    default => $home,
  }

  file {$user_home:
    ensure => directory,
    owner  => 'root',
    group  => $group,
    mode   => '0750',
  }

  user {$name:
    ensure  => $ensure,
    home    => $user_home,
    groups  => $group,
    shell   => '/usr/lib/sftp-server',
    require => File[$user_home]
  }

  file {"${user_home}/${basedir}":
    ensure  => directory,
    mode    => $basedir_mode,
    owner   => $name,
    group   => $group,
    require => [ User[$name], Group[$group] ],
  }

  ssh_authorized_key {"sftponly_${name}":
    ensure  => $ensure,
    user    => $name,
    key     => $ssh_key,
    type    => $ssh_type,
    options => $ssh_options,
    require => User[$name],
  }

  augeas {"internal-sftp for ${name}":
    context => '/files/etc/ssh/sshd_config',
    changes => 'set Subsystem/sftp "internal-sftp -u 0002"',
    notify  => Service['ssh'],
  }

  augeas {"match group for ${name}":
    context => '/files/etc/ssh/sshd_config',
    changes => [
      "set Match/Condition/group ${group}",
      'set Match/Settings/ChrootDirectory %h',
      'set Match/Settings/X11Forwarding no',
      'set Match/Settings/AllowTcpForwarding no',
      'set Match/Settings/ForceCommand "internal-sftp -u 0002"',
    ],
    notify  => Service['ssh'],
  }

}

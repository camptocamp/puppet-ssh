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
# [*password*]
#   Set the user's password
#
# [*present*]
#   Define if this account is present or absent
#
# [*home*]
#   The home directory of the user
#
# [*manage_home*]
#   Select wether to manage the user's home directory
#
# [*basedir*]
#   This directory will be used to store files
#
# [*basedir_mode*]
#   The desired permissions for the base directory
#
# [*manage_basedir*]
#   Select wether to manage the directory given in the basedir parameter.
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
  $ssh_key        = false,
  $ssh_type       = 'ssh-rsa',
  $ssh_options    = [],
  $password       = false,
  $ensure         = 'present',
  $home           = false,
  $basedir        = 'uploads',
  $basedir_mode   = '2775',
  $manage_home    = true,
  $manage_basedir = true,
  $group          = 'sftponly'
) {

  $using_ssh_key = $ssh_key ? {
    false   => false,
    default => true,
  }

  if ($using_ssh_key == false) and ($password == false) {
    fail "Must specify at least one of 'password' or 'ssh_key' in ssh::sftp::user[$name]"
  }

  $user_home = $home ? {
    false   => "/home/${name}",
    default => $home,
  }

  if $manage_home {
    file {$user_home:
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '0750',
    }
  }

  $nologin_path = $lsbdistid ? {
    /Debian|Ubuntu/ => '/usr/sbin/nologin',
    /RedHat|CentOS/ => '/sbin/nologin',
  }

  user {$name:
    ensure     => $ensure,
    password   => $password ? { false => undef, default => $password },
    home       => $user_home,
    groups     => $group,
    shell      => $nologin_path,
  }

  if $manage_basedir {
    file {"${user_home}/${basedir}":
      ensure  => directory,
      mode    => $basedir_mode,
      owner   => $name,
      group   => $group,
      require => [ User[$name], Group[$group] ],
    }
  }

  if $using_ssk_key {
    ssh_authorized_key {"sftponly_${name}":
      ensure  => $ensure,
      user    => $name,
      key     => $ssh_key,
      type    => $ssh_type,
      options => $ssh_options,
      require => User[$name],
    }
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

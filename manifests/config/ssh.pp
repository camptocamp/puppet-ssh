/*

== Definition: ssh::config::ssh

Set a parameter in /etc/ssh/ssh_config

Parameters:
- *ensure*: present/absent;
- *value*: value of the parameter

Example usage:

    ssh::config::ssh {'ForwardX11':
      value => 'yes',
    }

*/

define ssh::config::ssh (
$ensure='present',
$value=''
) {

  case $ensure {
    'present': {
      $changes = "set ${name} ${value}"
    }

    'absent': {
      $changes = "rm ${name}"
    }

    'default': { fail("Wrong value for ensure: ${ensure}") }
  }

  augeas {"Set ${name} in /etc/ssh/ssh_config":
    context => '/files/etc/ssh/ssh_config',
    changes => $changes,
  }
}

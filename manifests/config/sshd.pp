/*

== Definition: ssh::config::sshd

Set a parameter in /etc/ssh/sshd_config

Parameters:
- *ensure*: present/absent;
- *value*: value of the parameter

Example usage:

    ssh::config::sshd {'PasswordAuthenticator':
      value => 'yes',
    }

*/

define ssh::config::sshd (
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

  augeas {"Set ${name} in /etc/ssh/sshd_config":
    context => '/files/etc/ssh/sshd_config',
    changes => $changes,
  }
}

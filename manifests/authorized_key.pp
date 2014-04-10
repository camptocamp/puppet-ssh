define ssh::authorized_key(
  $public_key = regsubst($name, '^(\S+) on \S+$', '\1'),
  $user       = regsubst($name, '^\S+ on (\S+)$', '\1'),
) {
  validate_hash($::ssh::public_keys)

  if $public_key in $::ssh::authorized_keys[$user]['public_keys'] {
    $ensure = present
  } else {
    $ensure = absent
  }

  ssh_authorized_key { "${public_key} on ${user}":
    ensure => $ensure,
    user   => $user,
    type   => $::ssh::public_keys[$public_key]['type'],
    key    => $::ssh::public_keys[$public_key]['key'],
  }
}

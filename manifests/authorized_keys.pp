define ssh::authorized_keys(
  $user        = $name,
  $public_keys = [],
) {
  validate_array($public_keys)
  validate_hash($::ssh::public_keys)

  $authorized_keys = suffix(keys($::ssh::public_keys), " on ${user}")
  ssh::authorized_key { $authorized_keys: }
}

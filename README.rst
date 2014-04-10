=================
SSH Puppet module
=================

-----
Usage
-----

include ssh

You can define your SSH authorized_keys in hiera:

First list you public_keys:

```
---
ssh::public_keys:
  foo:
    type: ssh-rsa
    key: FOO'S-RSA-PUBLIC-KEY
  bar:
    type: ssh-rsa
    key: BAR'S-RSA-PUBLIC-KEY
  baz:
    type: ssh-rsa
    key: BAZ'S-RSA-PUBLIC-KEY
```

Then define rules:

```
---
ssh::authorized_keys:
  foo:
    public_keys:
      - foo
      - bar
  bar:
    public_keys:
      - bar
  baz:
    public_keys:
      - foo
      - bar
      - baz
```
Every key listed in `ssh::authorized_keys[$user]['public_keys']` will be ensured `present`.
Every key listed in `ssh::public_keys` and not present in `ssh::authorized_keys[$user]['public_keys']` will be ensured `absent`.

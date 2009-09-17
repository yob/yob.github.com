---
layout: default
---
I've never been able to refresh all the keys in the GPG keyring stored on my Xen host with rimuhosting.com, only ever managing to get the following cryptic output:

    jh@gir:~$ gpg --refresh
    gpg: keyserver communications error: general error
    gpg: WARNING: unable to refresh key C8692763 via hkp://subkeys.pgp.net: general error
    gpg: keyserver communications error: general error
    gpg: WARNING: unable to refresh key C6B3AE7E via hkp://subkeys.pgp.net/: general error
    gpg: keyserver communications error: general error
    gpg: WARNING: unable to refresh key 4B729625 via hkp://keyring.debian.org: general error
    gpg: keyserver communications error: general error
    gpg: WARNING: unable to refresh key B83D761C via hkp://keyserver.kjsl.com:11371: general error
    gpg: keyserver communications error: general error
    gpg: WARNING: unable to refresh key 6D67F790 via hkp://keyring.debian.org: general error
    gpg: keyserver communications error: general error
    gpg: WARNING: unable to refresh key 8F068012 via hkp://wwwkeys.us.pgp.net: general error
    gpg: keyserver communications error: general error
    gpg: WARNING: unable to refresh key 6E25E283 via hkp://pgpkeys.mit.edu: general error
    gpg: keyserver communications error: general error
    gpg: WARNING: unable to refresh key 6538F5BF via http://keyserver.debian.org: general error
    gpg: keyserver communications error: general error
    gpg: WARNING: unable to refresh key 5706A4B4 via hkp://subkeys.pgp.net: general error
    gpg: keyserver communications error: general error
    gpg: WARNING: unable to refresh key 330C4A75 via x-hkp://subkeys.pgp.net: general error
    gpg: keyserver communications error: general error
    gpg: WARNING: unable to refresh key 46399138 via http://quiston.tpsa.com/crypto/0x46399138.asc: general error
    gpg: keyserver communications error: general error
    gpg: WARNING: unable to refresh key 3FD25C84 via hkp://keyring.debian.org: general error
    gpg: refreshing 1095 keys from hkp://subkeys.pgp.net
    gpg: keyserver communications error: general error
    gpg: keyserver refresh failed: general error

For future reference, it appears that the refresh function requires a surprisingly large chunk of memory to operate, and on my low memory VPS it wasn't able to get enough. Temporarily stopping some memory hungry processes while I ran the refresh worked like a charm.

Instead of providing a nice message explaining the issue we're given a cryptic "general error", so I've filed a [wishlist bug](https://bugs.g10code.com/gnupg/issue790) in the gnupg bug tracker.

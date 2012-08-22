---
layout: default
title: GPG Key Transition
---

I am transitioning my GPG key from an old 1024-bit DSA key to a new 4096-bit
RSA key. The old key will continue to be valid for some time but I prefer all
new correspondance to be encrypted with the new key. I will be making all
signatures going forward with the new key.

I have followed the [excellent
tutorial](http://www.debian-administration.org/users/dkg/weblog/48) from Daniel
Kahn Gillmor which also explains why this migration is needed.

Here is the signed transition statement (I have stolen most of it from
[Zack](http://upsilon.cc/~zack/key-transition.2010.txt)):

{% highlight bash %}
    -----BEGIN PGP SIGNED MESSAGE-----
    Hash: SHA1,SHA512

    I am transitioning GPG keys from an old 1024-bit DSA key to a new
    4096-bit RSA key.  The old key will continue to be valid for some time,
    but I prefer all new correspondance to be encrypted in the new key, and
    will be making all signatures going forward with the new key.

    This transition document is signed with both keys to validate the
    transition.

    If you have signed my old key, I would appreciate signatures on my new
    key as well, provided that your signing policy permits that without
    reauthenticating me.

    The old key, which I am transitioning away from, is:

      pub   1024D/B6D8A3F9 2003-03-14 James Healy <jimmy@deefa.com>
      Primary key fingerprint: D3B7 3E0E A30F 2A61 26AF  2B9B E286 B092 B6D8 A3F9

    The new key, to which I am transitioning, is:

      pub   4096R/F03AD7E5 2012-08-22 James Healy <jimmy@deefa.com>
      Primary key fingerprint: CB6C A538 D085 4682 56D9  DFFA 359A 8D52 F03A D7E5

    Please contact me via e-mail at <jimmy@deefa.com> or <james@yob.id.au> if you
    have any questions about this document or this transition.
    -----BEGIN PGP SIGNATURE-----
    Version: GnuPG v1.4.12 (GNU/Linux)

    iEYEARECAAYFAlA1EcYACgkQ4oawkrbYo/l6zwCePTB8TQbSJBGzyIkHuoxIHxn8
    tocAni2MTXmTG6oWfHQBDoMg+p6RQU71iQIcBAEBCgAGBQJQNRHGAAoJEDWajVLw
    Otfl5/sP/0h18LpctWlFyXEsYtADQiGnBveNIZDhdPwnJ4nxA0Y+UicrpW1FtVzT
    4vT6zOYKyLHHGSAL8dzzcybEPMlQyWsY3PLmAQL7QPf5z145+gCNUaMnLWPG20D2
    X6AoXIWnKmtgJ2oFP800U3KwbNKGdgSZFD072V0ry2fBf2pRekzg434QJ2lAyPo8
    TLRwqLXf9r4ipMkgyFpyPUNJa8Sm8WXW+Y2wkridzDXUqRTQ8ARNEMvVbx8yR/YW
    tWOwEySlNG0Z+vrKv3LZx/p3DiATIfwbbIjOsKUYe1UfLpOIBAes7O2LGi81GtZ8
    vkzjTYR3r3cSyUaKg973ISwVI83iMAqfR1Xjarl6HkaOHt2nhJaB8Ppz4FfA9EY0
    zuFrulDuaTnvOdEqQ01rQvYcYSvFSoCmTlbXdHiV8GWDB2K3jRO2LGlZWzSMMFRz
    UapS4HgABm8ZrK4gRXXiyFiDZ49Hqi+lcruCR4L6qk/0MG7RiKN/2Ptvqy55pCMa
    /vKlcySkGRIE6qI1NIDjnmtBDrxfnr8loi35bJ5xPjKY0iJiUgOIFBJqOZxpCLav
    v+QSnewpvCbLLCw57SO4IzLBT+pJwt2xSyBTumBxbHksQ5uQ0QEqVO2lM7cqGfx5
    n5k4lAMB7eeYT4QdEE2l9Nlqb28Kxh94m7+LwPGFDPul6O0sPHEW
    =R3SK
    -----END PGP SIGNATURE-----
{% endhighlight %}

For easier access, I have also published it in text format. You can check it with:

{% highlight bash %}
    $ gpg --keyserver keys.gnupg.net --recv-key 359A8D52F03AD7E5
    gpg: requesting key F03AD7E5 from hkp server keys.gnupg.net
    gpg: key F03AD7E5: public key "James Healy <james@yob.id.au>" imported
    gpg: Total number processed: 1
    gpg:               imported: 1  (RSA: 1)
    $ curl http://yob.id.au/files/key-transition-2012.txt | gpg --verify
{% endhighlight %}

I now need to gather some signatures for the new key. If this is appropriate
for you, please sign the new key if you signed the old one.

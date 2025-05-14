# sys-pgp

PGP operations through Qrexec in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
    *   [Passphrase](#passphrase)
    *   [Client API libraries](#client-api-libraries)
*   [Access Control](#access-control)
*   [Usage](#usage)
    *   [Service activation](#service-activation)
    *   [Key management on the server](#key-management-on-the-server)
        *   [Passphrase protection](#passphrase-protection)
        *   [Generate new keys](#generate-new-keys)
        *   [Import existing keys](#import-existing-keys)
    *   [Split key usage on the client](#split-key-usage-on-the-client)

## Description

Creates a PGP key holder named "sys-pgp", it will be the default target for
split-gpg and split-gpg2 calls for all qubes. Keys are stored in "sys-pgp",
and access to them is made from the client through Qrexec.

## Installation

*   Top:

```sh
sudo qubesctl top.enable mgmt sys-pgp
sudo qubesctl --targets=tpl-mgmt state.apply
sudo qubesctl state.apply sys-pgp.prefs-mgmt
sudo qubesctl --targets=tpl-sys-pgp,sys-pgp state.apply
sudo qubesctl top.disable mgmt sys-pgp
sudo qubesctl state.apply sys-pgp.prefs
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-pgp.create
sudo qubesctl --skip-dom0 --targets=tpl-mgmt state.apply mgmt.install
sudo qubesctl state.apply sys-pgp.prefs-mgmt
sudo qubesctl --skip-dom0 --targets=tpl-sys-pgp state.apply sys-pgp.install
sudo qubesctl --skip-dom0 --targets=sys-pgp state.apply sys-pgp.configure
```

<!-- pkg:end:post-install -->

Install on the client template:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-qubes-builder,tpl-dev state.apply sys-pgp.install-client
```

The client qube requires the split GPG client service to be enabled:

```sh
qvm-features QUBE service.split-gpg2-client 1
```

### Passphrase

In case you plan to use passphrase, install a GUI pinentry:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-sys-pgp state.apply sys-pgp.install-pinentry
```

### Client API libraries

If you are using an application that interacts using the GnuPG API instead of
the command-line such as Thunderbird, you will need to install on the client
a GPGME package specific to your client application. This is not covered by
default.

Install GPGME C API library on the client template:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-qubes-builder,tpl-dev state.apply sys-pgp.install-client-gpgme-c
```

Install GPGME C++ API library on the client template:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-qubes-builder,tpl-dev state.apply sys-pgp.install-client-gpgme-c++
```

Install GPGME Qt API library on the client template:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-qubes-builder,tpl-dev state.apply sys-pgp.install-client-gpgme-qt
```

Install GPGME Python API library on the client template:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-qubes-builder,tpl-dev state.apply sys-pgp.install-client-gpgme-python
```

## Access Control

_Default policy_: `any qube` can `ask` via the `@default` target if you allow
it to use split-gpg in `sys-pgp`.

Allow the `work` qubes to access `sys-pgp`, but not other qubes:

```qrexecpolicy
qubes.Gpg2 * work   sys-pgp  ask default_target=sys-pgp
qubes.Gpg2 * work   @default ask target=sys-pgp default_target=sys-pgp
qubes.Gpg2 * @anyvm @anyvm   deny
```

## Usage

Consult [upstream documentation](https://github.com/QubesOS/qubes-app-linux-split-gpg2)
on how to use split-gpg2.

On the following examples, we will consider `dev` as the client qube and
`ben` as the key user ID.

### Service activation

On `dom0`, enable the service `split-gpg2-client` for the client qube `dev`:

```sh
qvm-features dev service.split-gpg2-client 1
```

### Key management on the server

#### Passphrase protection

Save your PGP keys to `sys-pgp`, using isolated GnuPG home directory per qube
at `~/.gnupg/split-gpg/<QUBE>`.

Please note that adding a passphrase brings
[no additional value](https://www.qubes-os.org/doc/split-gpg):

> Having a passphrase on the key is of little value. An adversary who is
> capable of stealing the key from your vault would almost certainly also be
> capable of stealing the passphrase as you enter it. An adversary who
> obtains the passphrase can then use it in order to change or remove the
> passphrase from the key.

Generate a private keys without a passphrase, use the following when
generating a key pair: `--pinentry-mode loopback --passphrase ""`

If you have already set a passphrase for your private key, you can delete it
by providing the current passphrase to unlock the key, confirming and then
clicking `OK` with an empty passphrase (the dialog might appear twice):

```sh
gpg --homedir ~/.gnupg/split-gpg/dev --edit-key ben passwd
```

#### Generate new keys

You should use subkeys, but configuring this key type is for advanced users
and out of scope for this document. Please refer to an external source.

Please note that the use of Sequoia-PGP over GnuPG is preferred.

On the qube `sys-pgp`. Create the isolated directory for the client qube
`dev`:

```sh
mkdir -p -- ~/.gnupg/split-gpg/dev
```

Generate keys for the client qube `dev`:

```sh
sq key generate --own-key --name ben --email ben@example.com --output ben.pgp --rev-cert ben.rev --without-password
sq key delete --cert-fle=ben.pgp --output=ben.cert
gpg --homedir ~/.gnupg/split-gpg/dev --import ben.pgp
```

Copy the public key (certificate) to the client qube `dev`:

```sh
qvm-copy ben.cert
```

#### Import existing keys

On the qube `sys-pgp`, import keys for the client qube `dev`:

```sh
mkdir -p -- ~/.gnupg/split-gpg/dev
gpg --homedir ~/.gnupg/split-gpg/dev --import /path/to/secret.key
gpg --homedir ~/.gnupg/split-gpg/dev --list-secret-keys
```

### Split key usage on the client

On the client qube `dev`, import the public part of your key:

```sh
gpg --import ~/QubesIncoming/sys-pgp/ben.cert
```

Test listing the secret key:

```sh
gpg --list-secret-keys
```

Test signing a message:

```sh
printf '%s' "test" | gpg --clearsign -u test@example.com
```

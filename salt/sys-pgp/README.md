# sys-pgp

PGP operations through Qrexec in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Access Control](#access-control)
*   [Usage](#usage)

## Description

Creates a PGP key holder named "sys-pgp", it will be the default target for
split-gpg and split-gpg2 calls for all qubes. Keys are stored in "sys-pgp",
and access to them is made from the client through Qrexec.

## Installation

*   Top:

```sh
sudo qubesctl top.enable sys-pgp
sudo qubesctl --targets=tpl-sys-pgp,sys-pgp state.apply
sudo qubesctl top.disable sys-pgp
sudo qubesctl state.apply sys-pgp.prefs
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-pgp.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-pgp state.apply sys-pgp.install
sudo qubesctl --skip-dom0 --targets=sys-pgp state.apply sys-pgp.configure
sudo qubesctl state.apply sys-pgp.prefs
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

Save your PGP keys to `sys-pgp`, using isolated GnuPG home directory per qube
at `~/.gnupg/split-gpg/<QUBE>`.

On `dom0`, enabled the service `split-gpg2-client` for the client qube `dev`:

```sh
qvm-features dev service.split-gpg2-client 1
```

On the qube `sys-pgp`, generate or import keys for the client qube `dev`:

```sh
mkdir -p -- ~/.gnupg/split-gpg/dev
gpg --homedir ~/.gnupg/split-gpg/dev --import /path/to/secret.key
gpg --homedir ~/.gnupg/split-gpg/dev --list-secret-keys
```

On the qube `dev`, import the public part of your key:

```sh
gpg --import /path/to/public.key
```

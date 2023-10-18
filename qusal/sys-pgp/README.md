# sys-pgp

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Access Control](#access-control)
* [Usage](#usage)
* [Copyright](#copyright)

## Description

PGP operations through Qrexec on Qubes OS.

Creates a PGP key holder named "sys-pgp", it will be the default target for
split-gpg and split-gpg2 calls for all qubes. Keys are stored in "sys-pgp",
and access to them is made from the client through Qrexec.

## Installation

- Top:
```sh
qubesctl top.enable sys-pgp
qubesctl --targets=tpl-sys-pgp,sys-pgp state.apply
qubesctl top.disable sys-pgp
```

- State:
```sh
qubesctl state.apply sys-pgp.create
qubesctl --skip-dom0 --targets=tpl-sys-pgp state.apply sys-pgp.install
qubesctl --skip-dom0 --targets=sys-pgp state.apply sys-pgp.configure
```

Install on the client template:
```sh
qubesctl --skip-dom0 --targets=tpl-qubes-builder,tpl-dev state.apply sys-pgp.install-client
```

The client qube also requires the service to be enabled:
```sh
qvm-features qubes-builder service.split-gpg2-client
qvm-features dev service.split-gpg2-client
```

## Access Control

_Default policy_: `any qube` can `ask` via the `@default` target if you allow
it to use split-gpg in `sys-pgp`.

Allow the `work` qubes to access `sys-pgp`, but no other qubes from using the
Gpg RPC service:
```qrexecpolicy
qubes.Gpg2 * work   sys-pgp  ask default_target=sys-pgp
qubes.Gpg2 * work   @default ask target=sys-pgp default_target=sys-pgp
qubes.Gpg2 * @anyvm @anyvm   deny
```

## Usage

Full details are at [www.qubes-os.org/doc/split-gpg](https://www.qubes-os.org/doc/split-gpg/).

## Copyright

License: GPLv2+

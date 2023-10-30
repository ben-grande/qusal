# sys-sshfs

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Access Control](#access-control)
* [Credits](#credits)

## Description

SSH File System over Qrexec on Qubes OS.

Creates a SSH server qube named "sys-sshfs".
TODO

## Installation

The SSH connector service is only started if the service is enabled for that
qube in Dom0:
```
qvm-features QUBE service.qubes-sshfs 1
```

- Top:
```sh
qubesctl top.enable sys-sshfs
qubesctl --targets=tpl-sys-sshfs,sys-sshfs state.apply
qubesctl top.disable sys-sshfs
```

- State:
```sh
qubesctl state.apply sys-sshfs.create
qubesctl --skip-dom0 --targets=tpl-sys-sshfs state.apply sys-sshfs.install
qubesctl --skip-dom0 --targets=sys-sshfs state.apply sys-sshfs.configure
```

Install on the client template:
```sh
qubesctl --skip-dom0 --targets=QUBE state.apply sys-sshfs.install-client
```

Configure the client:
```sh
qubesctl --skip-dom0 --targets=QUBE state.apply sys-sshfs.configure-client
```

## Access Control

A `qusal.Sshfs` service is created to allow use of SSH File Transfer Protocol
over Qrexec. The default policy `asks` if you want to sync with the
`sys-sshfs` qube.

If you want to `allow` SSH between qubes, insert in you user policy file
`/etc/qubes/policy.d/30-user.policy` to allow the service using the following
format:
```qrexecpolicy
qusal.Sshfs * SOURCE @default allow target=TARGET default_target=DEFAULT_TARGET
```

## Usage

TODO

## Credits

- [Unman](https://github.com/unman/shaker/tree/master/share)

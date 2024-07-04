# sys-rsync

Rsync over Qrexec in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Access Control](#access-control)
*   [Usage](#usage)
    *   [Server](#server)
    *   [Client](#client)
*   [Credits](#credits)

## Description

Creates a Rsync server qube named "sys-rsync" to be a central document
store to which other qubes have access. This is a simple tool that allows
individual qubes read/write access to the store using Rsync, rather than using
`qvm-copy` or `qvm-move`.

The greatest problem with SSH is that with large file system, it can freeze
or be very slow to navigate the directories (not so much with Qrexec as the
connection does not go over the network) and chroots need to be configured by
the user.

## Installation

*   Top:

```sh
sudo qubesctl top.enable sys-rsync
sudo qubesctl --targets=tpl-sys-rsync,sys-rsync state.apply
sudo qubesctl top.disable sys-rsync
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-rsync.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-rsync state.apply sys-rsync.install
sudo qubesctl --skip-dom0 --targets=sys-rsync state.apply sys-rsync.configure
```

<!-- pkg:end:post-install -->

Install on the client template:

```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATE state.apply sys-rsync.install-client
```

The client qube requires the Rsync forwarder service to be enabled:

```sh
qvm-features QUBE service.rsync-client 1
```

## Access Control

A `qusal.Rsync` service is created to allow use of Rsync over Qrexec. The
default policy `asks` if you want to connect with the `sys-rsync` qube.

If you want to `allow` Rsync between qubes, insert in you user policy file
`/etc/qubes/policy.d/30-user.policy` to allow the service using the following
format:

```qrexecpolicy
qusal.Rsync * SOURCE @default allow target=TARGET
```

When the client can change the data on the server, it can also possibly
compromise the server or at least make it hold malicious files and propagate
the malicious data with client it is connected to.

## Usage

### Server

The default setting is to have a **read/write** store at `/home/user/shared`,
and a **read-only** directory at `/home/user/archive`. All the usual Rsync
configuration options are available and you can create other shared
directories at will. Additional configuration can be made by editing `.conf`
files in `/usr/local/etc/rsync.d/*.conf`. Because access appears to come from
localhost, host control directives will not work.

If you have more than one rsync server qube, you can use
[bind-dirs](https://www.qubes-os.org/doc/bind-dirs/) to change the available
folders on each server qube.

### Client

The Rsync connection is available with the socket `localhost:1839`.

Rsync the server `shared` read/write directory:

```sh
rsync --port=1839 localhost::shared /LOCAL/PATH/TO/RSYNC
```

Rsync the server `archive` read-only directory:

```sh
rsync --port=1839 localhost::archive /LOCAL/PATH/TO/RSYNC
```

## Credits

*   [Unman](https://github.com/unman/qubes-sync)

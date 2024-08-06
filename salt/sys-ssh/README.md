# sys-ssh

SSH over Qrexec in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Access Control](#access-control)
*   [Usage](#usage)
    *   [Server](#server)
    *   [Client](#client)
*   [Credits](#credits)

## Description

Creates a SSH server qube named "sys-ssh" to be a central document
store to which other qubes have access with SSH File Transfer Protocol, using
the tool sshfs. This is a simple tool that allows individual qubes to mount a
another qube's filesystem rather than using `qvm-copy` or `qvm-move`.

The greatest problem with the Rsync solution is that it makes copies of the
files or directories. This may be fine with a small amount of data, but with
large files, or large numbers of files, there's a significant overhead. SSH
File Transfer Protocol provides a way for clients to access files on the
server qube directly.

## Installation

*   Top:

```sh
sudo qubesctl top.enable sys-ssh
sudo qubesctl --targets=tpl-sys-ssh,sys-ssh state.apply
sudo qubesctl top.disable sys-ssh
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-ssh.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-ssh state.apply sys-ssh.install
```

<!-- pkg:end:post-install -->

Install on the client template:

```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATE state.apply sys-ssh.install-client
```

The client qube requires the SSH forwarder service to be enabled:

```sh
qvm-features QUBE service.ssh-client 1
```

## Access Control

A `qusal.Ssh` service is created to allow use of SSH over Qrexec. The default
policy `asks` if you want to connect with the `sys-ssh` qube.

If you want to `allow` SSH between qubes, insert in you user policy
file `/etc/qubes/policy.d/30-user.policy` to allow the service using the
following format:

```qrexecpolicy
qusal.Ssh   * SOURCE @default allow target=TARGET
```

When the client can change the data on the server, it can also possibly
compromise the server or at least make it hold malicious files and propagate
the malicious data with clients it is connected to.

## Usage

### Server

It is possible to constrain access to files on the server, using (e.g) SSH
chroots and access control mechanisms. This is left for the user to configure.

Passwordless login through empty passwords are allowed when the host matches
127.0.0.1, it makes no sense to restrict the access if the Qrexec call was
already permitted.

### Client

The SSH connection is available with the socket `localhost:1840`.

From the client, mount the server `/home/user` directory as a SSH File System
in the client `/home/user/sshfs` directory:

```sh
mkdir -- ~/sshfs
sshfs -p 1840 localhost:/home/user /home/user/sshfs
```

## Credits

*   [Unman](https://github.com/unman/qubes-sync)

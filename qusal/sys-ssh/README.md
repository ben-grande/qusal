# sys-ssh

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Access Control](#access-control)
* [Usage](#usage)
  * [Server](#server)
  * [Client](#client)
    * [Enable Passwordless login](#enable-passwordless-login)
    * [Mount the server file system](#mount-the-server-file-system)
* [Credits](#credits)

## Description

SSH over Qrexec on Qubes OS.

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

- Top:
```sh
qubesctl top.enable sys-ssh
qubesctl --targets=tpl-sys-ssh,sys-ssh state.apply
qubesctl top.disable sys-ssh
```

- State:
```sh
qubesctl state.apply sys-ssh.create
qubesctl --skip-dom0 --targets=tpl-sys-ssh state.apply sys-ssh.install
qubesctl --skip-dom0 --targets=sys-ssh state.apply sys-ssh.configure
```

Install on the client template:
```sh
qubesctl --skip-dom0 --targets=TEMPLATE state.apply sys-ssh.install-client
```

The client qube requires the SSH forwarder service to be enabled:
```
qvm-features QUBE service.ssh-setup 1
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

### Client

#### Enable Passwordless login

The client can be the sys-ssh-agent's client and not hold the private keys at
all. Consult sys-ssh-agent documentation for more information.

In the client, create SSH keys and copy them to the server:
```sh
ssh-keygen -t ed25519
qvm-copy .ssh/id_ed25519.pub
```

On the server, create the SSH directory and copy the client key to the
authorized list:
```sh
mkdir -m 0700 ~/.ssh
cat ~/QubesIncoming/<client>/id_ed25519.pub | tee -a ~/.ssh/authorized_keys
```

#### Mount the server file system

The SSH connection is available with the socket `localhost:1840`.

From the client, mount the server `/home/user` directory as a SSH File System
in the client `/home/user/sshfs` directory:
```sh
mkdir ~/sshfs
sshfs -p 1840 localhost:/home/user /home/user/sshfs
```

## Credits

- [Unman](https://github.com/unman/qubes-sync)

# ssh

SSH remote login client in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Setup SSH client AppVM ssh and a DispVM Template "dvm-ssh".
It's use is plain simple, SSH to servers, no extra configuration is required.
When saving the SSH configuration is necessary, use the ssh qube. If login
in as a one time connection or to an untrusted host use a DispVM based on
"dvm-ssh" for disposability.

## Installation

*   Top:

```sh
sudo qubesctl top.enable ssh
sudo qubesctl --targets=tpl-ssh,dvm-ssh,ssh state.apply
sudo qubesctl top.disable ssh
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply ssh.create
sudo qubesctl --skip-dom0 --targets=tpl-ssh state.apply ssh.install
sudo qubesctl --skip-dom0 --targets=dvm-ssh,ssh state.apply ssh.configure
```

<!-- pkg:end:post-install -->

## Usage

Create DispVMs based on the Template for DispVMs "dvm-ssh" for disposable SSH
sessions or create AppVMs based on "tpl-ssh", such as the "ssh" qube for for
preserving the SSH configuration client side.

The client qube can enhanced by being:

*   sys-ssh-agent's client and not storing the SSH keys on the client; or
*   sys-git's client and fetching from qubes and push to remote servers.

The server requires the OpenSSH server to be installed.

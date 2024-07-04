# dev

Development environment in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Access Control](#access-control)
*   [Usage](#usage)

## Description

Setup a development qube named "dev". Defines the user interactive shell,
installing goodies, applying dotfiles, being client of sys-pgp, sys-git and
sys-ssh-agent. The qube has netvm but can reach remote servers if the policy
allows.

## Installation

*   Top:

```sh
sudo qubesctl top.enable dev
sudo qubesctl --targets=tpl-dev,dvm-dev,dev state.apply
sudo qubesctl top.disable dev
proxy_target="$(qusal-report-updatevm-origin)"
if test -n "${proxy_target}"; then
  sudo qubesctl --skip-dom0 --targets="${proxy_target}" state.apply sys-net.install-proxy
fi
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply dev.create
sudo qubesctl --skip-dom0 --targets=tpl-dev state.apply dev.install
sudo qubesctl --skip-dom0 --targets=dvm-dev state.apply dev.configure-dvm
sudo qubesctl --skip-dom0 --targets=dev state.apply dev.configure
proxy_target="$(qusal-report-updatevm-origin)"
if test -n "${proxy_target}"; then
  sudo qubesctl --skip-dom0 --targets="${proxy_target}" state.apply sys-net.install-proxy
fi
```

<!-- pkg:end:post-install -->

If you want some Python goodies, you can install them:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-dev state.apply dev.install-python-tools
```

The installation will make the Qusal TCP Proxy available in the `updatevm`
(after it is restarted in case it is template based). If you want to have the
proxy available on a `netvm` that is not deployed by Qusal, install the Qusal
TCP proxy on the templates of your `netvm`:

```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATE state.apply sys-net.install-proxy
```

Remember to restart the `netvms` after the proxy installation for the changes
to take effect.

## Access Control

_Default policy_: `denies` `all` qubes from calling `qusal.ConnectTCP`

Allow qube `dev` to `connect` to `github.com:22` via `disp-sys-net` but not to
any other host or via any other qube:

```qrexecpolicy
qusal.ConnectTCP +github.com+22 dev @default allow target=disp-sys-net
qusal.ConnectTCP *              dev @anyvm   deny
```

## Usage

The development qube `dev` can be used for:

*   code development;
*   building programs;
*   signing commits, tags, pushes and verifying with split-gpg;
*   fetching and pushing to and from local qube repository with split-git; and
*   fetching and pushing to and from remote repository with split-ssh-agent
    and without direct network connection, you can open port to the desired
    SSH or HTTP server.

As the `dev` qube has no netvm, configure the Qrexec policy to allow or ask
calls to the `qusal.ConnectTCP` RPC service, so the qube can communicate with
a remote repository for example.

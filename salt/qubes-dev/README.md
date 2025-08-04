# qubes-dev

Development environment for Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Access Control](#access-control)
*   [Usage](#usage)

## Description

Setup a development qube named "qubes-dev", dedicated to contributing to Qubes
OS repositories. As there there is a very broad set of repositories, only
common packages will be installed. The qube has netvm but can reach remote
servers if the policy allows.

## Installation

*   Top:

```sh
sudo qubesctl top.enable qubes-dev
sudo qubesctl --targets=tpl-qubes-dev,dvm-qubes-dev,qubes-dev state.apply
sudo qubesctl top.disable qubes-dev
proxy_target="$(qusal-report-updatevm-origin)"
if test -n "${proxy_target}"; then
  sudo qubesctl --skip-dom0 --targets="${proxy_target}" state.apply sys-net.install-proxy
fi
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply qubes-dev.create
sudo qubesctl --skip-dom0 --targets=tpl-qubes-dev state.apply qubes-dev.install
sudo qubesctl --skip-dom0 --targets=dvm-qubes-dev state.apply qubes-dev.configure-dvm
sudo qubesctl --skip-dom0 --targets=qubes-dev state.apply qubes-dev.configure
proxy_target="$(qusal-report-updatevm-origin)"
if test -n "${proxy_target}"; then
  sudo qubesctl --skip-dom0 --targets="${proxy_target}" state.apply sys-net.install-proxy
fi
```

<!-- pkg:end:post-install -->

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

Allow qube `qubes-dev` to `connect` to `github.com:22` via `disp-sys-net` but
not to any other host or via any other qube:

```qrexecpolicy
qusal.ConnectTCP +github.com+22 qubes-dev @default allow target=disp-sys-net
qusal.ConnectTCP *              qubes-dev @anyvm   deny
```

## Usage

The development qube `qubes-dev` can be used for:

*   everything the [dev](../dev/README.md) qube can do;
*   contributing to Qubes OS

As the `qubes-dev` qube has no netvm, configure the Qrexec policy to allow or
ask calls to the `qusal.ConnectTCP` RPC service, so the qube can communicate
with a remote repository for example.

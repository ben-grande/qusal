# sys-tailscale

Tailscale environment in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Install Tailscale and use it on the "sys-tailscale" or with any other qube you
want to install.

## Installation

*   Top:

```sh
sudo qubesctl top.enable sys-tailscale
sudo qubesctl --targets=tpl-sys-tailscale state.apply
sudo qubesctl top.disable sys-tailscale
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-tailscale.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-tailscale state.apply sys-tailscale.install
```

<!-- pkg:end:post-install -->

The Tailscale qube requires the Tailscale service to be enabled:

```sh
qvm-features QUBE service.tailscale 1
```

## Usage

Authenticate to your Tailnet by following the upstream instructions to
[generate an auth key](https://tailscale.com/kb/1085/auth-keys#generate-an-auth-key)
for use in automated setups. For interactive setups, get the authorization
link from the following command:

```sh
sudo tailscale up
```

On the Tailscale web interface, authorize the new device.

You may want to [disable automatic key
expiry](https://tailscale.com/kb/1085/auth-keys#key-expiry) to avoid having to
redo the authentication steps.

There are various functionalities Tailscale provides, consult
[upstream documentation](https://tailscale.com/kb) for more information. There
is also an
[introductory video](https://tailscale.dev/blog/get-started-in-10-nov2023)
covering the basics.

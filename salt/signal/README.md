# signal

Signal messaging app in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Install Signal Desktop and creates an app qube named "signal".

## Installation

*   Top:

```sh
sudo qubesctl top.enable signal
sudo qubesctl --targets=tpl-signal,signal state.apply
sudo qubesctl top.disable signal
sudo qubesctl state.apply signal.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply signal.create
sudo qubesctl --skip-dom0 --targets=tpl-signal state.apply signal.install
sudo qubesctl --skip-dom0 --targets=signal state.apply signal.configure
sudo qubesctl state.apply signal.appmenus
```

<!-- pkg:end:post-install -->

## Usage

You may use different Signal accounts for different identities, such as
personal, work or pseudonym. Maintain the `signal` qube pristine and clone it
to the assigned domain, `personal-signal`, `work-signal`, `anon-signal`. If
you don't maintain the qube pristine, you will have to apply the firewall
rules manually.

Signal might loose connectivity due to [upstream rotating IP
addresses](https://support.signal.org/hc/en-us/articles/360007320291) with the
use of [CDNs to evade
blocking](https://signal.org/blog/looking-back-on-the-front/).
You will have to reapply the firewall rules eventually.

TODO: Is it worth using the firewall? If you allow all [cloudfront.net
IPs](https://ip-ranges.amazonaws.com/ip-ranges.json) for region "GLOBAL", what
is blocking an attacker from using that to host his malicious callback server?
Recently (2023-11-11) signal stopped working with the current firewall.

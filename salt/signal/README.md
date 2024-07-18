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
to the assigned domain, `personal-signal`, `work-signal`, `anon-signal`.

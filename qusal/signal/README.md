# signal

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Signal messaging app on Qubes OS.

Install Signal Desktop and creates an app qube named "signal".

## Installation

- Top:
```sh
qubesctl top.enable signal
qubesctl --targets=tpl-signal,signal state.appply
qubesctl top.disable signal
```

- State:
```sh
qubesctl state.apply signal.create
qubesctl --skip-dom0 --targets=tpl-signal state.apply signal.install
qubesctl --skip-dom0 --targets=signal state.apply signal.configure
```

## Usage

You may use different Signal accounts for different identities, such as
personal, work or pseudonym. Maintain the `signal` qube pristine and clone it
to the assigned domain, `personal-signal`, `work-signal`, `anon-signal`. If
you don't maintain the qube pristine, you will have to apply the firewall
rules manually.

# signal

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Copyright](#copyright)

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

## Copyright

License: GPLv2+

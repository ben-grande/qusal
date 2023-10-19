# debian-minimal

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Copyright](#copyright)

## Description

Download and configure the Debian Minimal Template.

## Installation

- Top:
```sh
qubesctl top.enable templates.debian-minimal
qubesctl --targets=debian-12-minimal state.apply
qubesctl top.disable templates.debian-minimal
```
- State:
```sh
qubesctl state.apply templates.debian-minimal.create
qubesctl --skip-dom0 --targets=debian-12-minimal state.apply templates.debian-minimal.install
```

## Copyright

License: GPLv2+

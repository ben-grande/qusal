# fedora

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Copyright](#copyright)

## Description

Download and configure the Fedora Template.

## Installation

- Top:
```sh
qubesctl top.enable templates.fedora
qubesctl --targets=fedora-38 state.apply
qubesctl top.disable templates.fedora
```
- State:
```sh
qubesctl state.apply templates.fedora.create
qubesctl --skip-dom0 --targets=fedora-38 state.apply templates.fedora.install
```

## Copyright

License: GPLv2+

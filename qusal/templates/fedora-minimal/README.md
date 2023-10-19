# fedora-minimal

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Copyright](#copyright)

## Description

Download and configure the Fedora Minimal Template.

## Installation

- Top:
```sh
qubesctl top.enable templates.fedora-minimal
qubesctl --targets=fedora-38-minimal state.apply
qubesctl top.disable templates.fedora-minimal
```
- State:
```sh
qubesctl state.apply templates.fedora-minimal.create
qubesctl --skip-dom0 --targets=fedora-38-minimal state.apply templates.fedora-minimal.install
```

## Copyright

License: GPLv2+

# debian-minimal

## Table of Contents

* [Description](#description)
* [Installation](#installation)

## Description

Download and configure the Debian Minimal Template.

## Installation

- Top:
```sh
qubesctl top.enable debian-minimal
qubesctl --targets=debian-12-minimal state.apply
qubesctl top.disable debian-minimal
```
- State:
```sh
qubesctl state.apply debian-minimal.create
qubesctl --skip-dom0 --targets=debian-12-minimal state.apply debian-minimal.install
```

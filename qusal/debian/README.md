# debian

## Table of Contents

* [Description](#description)
* [Installation](#installation)

## Description

Download and configure the Debian Template.

## Installation

- Top:
```sh
qubesctl top.enable debian
qubesctl --targets=debian-12 state.apply
qubesctl top.disable debian
```
- State:
```sh
qubesctl state.apply debian.create
qubesctl --skip-dom0 --targets=debian-12 state.apply debian.install
```

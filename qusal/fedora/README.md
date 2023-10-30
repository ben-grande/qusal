# fedora

## Table of Contents

* [Description](#description)
* [Installation](#installation)

## Description

Download and configure the Fedora Template.

## Installation

- Top:
```sh
qubesctl top.enable fedora
qubesctl --targets=fedora-38 state.apply
qubesctl top.disable fedora
```
- State:
```sh
qubesctl state.apply fedora.create
qubesctl --skip-dom0 --targets=fedora-38 state.apply fedora.install
```

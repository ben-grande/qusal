# dom0

## Table of Contents

* [Description](#description)
* [Installation](#installation)

## Description

Dom0 environment on Qubes OS.

Configure Dom0 window manager, install packages, backup scripts and profile etc.

## Installation

- Top
```sh
qubesctl top.enable dom0
qubesctl state.apply
qubesctl top.disable dom0
```

- State
```sh
qubesctl state.apply dom0
```

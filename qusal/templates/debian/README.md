# Debian Template

## Table of Contents

* [Description](#description)
* [Installation](#installation)

## Description

Download and configure the Debian Template.

## Installation

- Top:
```sh
qubesctl top.enable templates.debian
qubesctl --targets=debian-12 state.apply
qubesctl top.disable templates.debian
```
- State:
```sh
qubesctl state.apply templates.debian.create
qubesctl --skip-dom0 --targets=debian-12 state.apply templates.debian.install
```

# Whonix

## Table of Contents

* [Description](#description)
* [Installation](#installation)

## Description

Download and configure Whonix.

## Installation

- Top:
```sh
qubesctl top.enable templates.whonix
qubesctl state.apply
qubesctl top.disable templates.whonix
qubesctl state.apply qvm.anon-whonix
qubesctl state.apply qvm.whonix-ws-dvm
```
- State:
```sh
qubesctl state.apply templates.whonix.create
qubesctl state.apply qvm.anon-whonix
qubesctl state.apply qvm.whonix-ws-dvm
```

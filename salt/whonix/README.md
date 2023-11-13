# whonix

Whonix Template in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Creates the Whonix Gateway and Workstation templates as well as a Disposable
Template based on it.

## Installation

- Top:
```sh
qubesctl top.enable whonix
qubesctl state.apply
qubesctl top.disable whonix
qubesctl state.apply qvm.anon-whonix
qubesctl state.apply qvm.whonix-ws-dvm
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply whonix.create
qubesctl state.apply qvm.anon-whonix
qubesctl state.apply qvm.whonix-ws-dvm
```
<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.

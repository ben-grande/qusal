# fedora

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

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

## Usage

AppVMs and StandaloneVMs can be based on this template.

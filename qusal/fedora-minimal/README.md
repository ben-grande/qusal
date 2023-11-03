# fedora-minimal

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Download and configure the Fedora Minimal Template.

## Installation

- Top:
```sh
qubesctl top.enable fedora-minimal
qubesctl --targets=fedora-38-minimal state.apply
qubesctl top.disable fedora-minimal
```
- State:
```sh
qubesctl state.apply fedora-minimal.create
qubesctl --skip-dom0 --targets=fedora-38-minimal state.apply fedora-minimal.install
```

## Usage

AppVMs and StandaloneVMs can be based on this minimal template.

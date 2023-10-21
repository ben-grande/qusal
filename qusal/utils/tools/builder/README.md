# builder

## Table of Contents

* [Description](#description)
* [Installation](#installation)

## Description

Build tools for packaging on Qubes OS.

This is not necessary for qubes-builder, it is just a set of useful tools for
building packages in UNIX distributions.

## Installation

Install builder tools on templates:
```sh
qubesctl --skip-dom0 --targets=TEMPLATEVMS state.apply utils.tools.builder.core
```
Install documentation tools on templates:
```sh
qubesctl --skip-dom0 --targets=TEMPLATEVMS state.apply utils.tools.builder.doc
```

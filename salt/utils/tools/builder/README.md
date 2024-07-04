# builder

Build tools for packaging in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

This is not necessary for qubes-builder, it is just a set of useful tools for
building packages in UNIX distributions.

## Installation

Install builder tools on templates:

```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATEVMS state.apply utils.tools.builder.core
```

Install documentation tools on templates:

```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATEVMS state.apply utils.tools.builder.doc
```

## Usage

Standard builder usage, no extra configuration required.

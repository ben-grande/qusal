# reader

Reader environment as the default_dispvm in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
* [Credits](#credits)

## Description

Create a disposable template for reading documents and viewing images called
"dvm-reader". It is designated to be the "default_dispvm", because of this,
there is no "netvm", but if you assign one, you will get networking as the
necessary packages will be installed in the template.

## Installation

- Top:
```sh
qubesctl top.enable reader
qubesctl --targets=tpl-reader state.apply
qubesctl top.disable reader
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply reader.create
qubesctl --skip-dom0 --targets=tpl-reader state.apply reader.install
```
<!-- pkg:end:post-install -->

## Usage

The intended usage of this qube is a receiver of incoming files that the call
originator/client did no trust to open in its environment. When you run
`qvm-open-in-dvm` from a qube and it is using the global preferences default
`default_dispvm`, it will open the file to be read in a disposable based on
`dvm-reader`.

## Credits

- [Unman](https://github.com/unman/shaker/tree/main/reader)

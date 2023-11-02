# reader

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Credits](#credits)

## Description

Reader environment as the default_dispvm on Qubes OS.

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
```sh
qubesctl state.apply reader.create
qubesctl --skip-dom0 --targets=tpl-reader state.apply reader.install
```

## Credits

- [Unman](https://github.com/unman/shaker/tree/main/reader)

# reader

Reader environment as the default_dispvm in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)
*   [Credits](#credits)

## Description

Create a disposable template for reading documents and viewing images called
"dvm-reader". It is designated to be the "default_dispvm", because of this,
there is no "netvm", but if you assign one, you will get networking as the
necessary packages will be installed in the template.

## Installation

*   Top:

```sh
sudo qubesctl top.enable reader
sudo qubesctl --targets=tpl-reader,dvm-reader state.apply
sudo qubesctl top.disable reader
sudo qubesctl state.apply reader.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply reader.create
sudo qubesctl --skip-dom0 --targets=tpl-reader state.apply reader.install
sudo qubesctl --skip-dom0 --targets=dvm-reader state.apply reader.configure
sudo qubesctl state.apply reader.appmenus
```

<!-- pkg:end:post-install -->

## Usage

The intended usage of this qube is a receiver of incoming files that the call
originator/client did no trust to open in its environment. When you run
`qvm-open-in-dvm` from a qube and it is using the global preferences default
`default_dispvm`, it will open the file to be read in a disposable based on
`dvm-reader`.

By default, there is no `netvm`, thus allowing you to set the networking chain
you want before the disposable makes a connection.

## Credits

*   [Unman](https://github.com/unman/shaker/tree/main/reader)

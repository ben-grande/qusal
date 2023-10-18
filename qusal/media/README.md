# media

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Copyright](#copyright)

## Description

Media opener through disposables on Qubes OS.

Creates the offline "media" qube for storing multimedia files and open the
files in a named disposable "disp-media" via MIME configuration.

## Installation

- Top:
```sh
qubesctl top.enable media
qubesctl --targets=tpl-media,media state.apply
qubesctl top.disable media
```

- State:
```sh
qubesctl state.apply media.create
qubesctl --skip-dom0 --targets=tpl-media state.apply media.install
qubesctl --skip-dom0 --targets=media state.apply media.configure
```

## Copyright

License: GPLv3+

Credits:
- [Unman](https://github.com/unman/shaker/tree/master/multimedia)

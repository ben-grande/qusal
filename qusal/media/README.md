# media

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
* [Credits](#credits)

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

## Usage

You will store multimedia files in the "media" qube. When you try to open a
file in that qube, it will open instead in the disposable "disp-media".

No file browser is installed in the "media" qube as code execution exploits in
file browsers are common when rendering thumbnails, indexing file name,
automatically running scripts saved in the home directory. You are open to
forward files from the "media" qube to "disp-media" by running `xdg-open
/path/file` or more explicitly, `qvm-open-in-dvm /path/file`.

## Credits

- [Unman](https://github.com/unman/shaker/tree/main/multimedia)

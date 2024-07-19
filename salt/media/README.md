# media

Media opener through disposables in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)
*   [Credits](#credits)

## Description

Creates the offline "media" qube for storing multimedia files and open the
files in a named disposable "disp-media" via MIME configuration. You can also
connect any disposable qube based on "dvm-media" to a netvm and gather media
over the network.

## Installation

*   Top:

```sh
sudo qubesctl top.enable media
sudo qubesctl --targets=tpl-media,media state.apply
sudo qubesctl top.disable media
sudo qubesctl state.apply media.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply media.create
sudo qubesctl --skip-dom0 --targets=tpl-media state.apply media.install
sudo qubesctl --skip-dom0 --targets=media state.apply media.configure
sudo qubesctl state.apply media.appmenus
```

<!-- pkg:end:post-install -->

## Usage

You will store multimedia files in the `media` qube. When you try to open a
file in that qube, it will open instead in the disposable "disp-media".

No file browser is installed in the `media` qube as code execution exploits in
file browsers are common when rendering thumbnails, indexing file name,
automatically running scripts saved in the home directory. You are open to
forward files from the "media" qube to "disp-media" by running `xdg-open
/path/file` or more explicitly, `qvm-open-in-dvm /path/file`.

You can personalize `mpv` by editing `$XDG_CONFIG_HOME/mpv/mpv.conf`.

## Credits

*   [Unman](https://github.com/unman/shaker/tree/main/multimedia)

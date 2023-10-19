# dotfiles

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
* [Copyright](#copyright)

## Description

Ben Grande's Dotfiles.

Configuration and scripts targeting:

- Usability:
  - Vi keybindings for application movement
  - Emacs keybindings for command-line editing
  - XDG Specification to not clutter $HOME
- Portability:
  - POSIX compliant code
  - Drop-in configuration files
  - Tested on Qubes OS Dom0, Debian, Fedora
- Tasks:
  - GUI: x11, gtk
  - SCM: git, tig, git-shell
  - Keys: gpg, ssh
  - Networking: curl, urlview, wget, w3m
  - Productivity: tmux, vim
  - Shell: sh, bash, zsh, less, dircolors

## Installation

You can simply deploy all configurations with:
```sh
./files/setup.sh
```
Or target specific ones by specifying the directory name:
```sh
./files/setup.sh sh bash
```
Note that some files might depend on other directories, specially `sh` which
is a base for `bash` and `zsh` but might also have environment variables for
`net` and `vim`.

Reload your shell:
```sh
exec $SHELL
```

Reload you X server:
```sh
. ~/.config/x11/xprofile
```

You need to logout and login again for some changes to take effect.

## Usage

The deployment replaces existing files and that is the goal, to make sure that
we have the same configuration of every machine. Support for local
configuration is implemented by including a local file per application.

Supported programs and the expected file names in `$HOME`:

- **bash**: .bashrc.local
- **git**:  .gitconfig.local
- **sh**:   .profile.local, .shrc.local
- **ssh**:  .ssh/config.d/*.conf, .ssh/known_hosts.d/*.host
- **tmux**: .tmux.conf.local
- **vim**:  .vimrc.local
- **x11**:  .xprofile.local
- **zsh**:  .zshrc.local

## Copyright

License: GPLv3+

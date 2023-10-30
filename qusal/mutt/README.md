# mutt

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Mutt text-based mail client on Qubes OS.

Create a mail client qube named "mutt" based on the program Mutt.

## Installation

- Top
```sh
qubesctl top.enable mutt
qubesctl --targets=tpl-mutt,mutt state.apply
qubesctl top.disable mutt
```

- State
```sh
qubesctl state.apply mutt.create
qubesctl --skip-dom0 --targets=tpl-mutt state.apply mutt.install
qubesctl --skip-dom0 --targets=mutt state.apply mutt.configure
```

## Usage

You will use local files to override the ones provided by this package. Few
options need to be set.

The file `~/.muttrc-credentials.local` will set some variables that will be
used by other configuration files sourced later:
```muttrc
set pgp_default_key = "0x1234567890ABCDEF"
set pgp_sign_as     = "0x1234567890ABCDEF"
set my_name         = "Bilbo Baggins"
set my_user         = "bilbo"
set my_server       = "shire.org"
set my_pass         = "mypassword"
```

You can define aliases in `~/.muttrc-aliases.local`.

If you want to override any option, put the settings in `~/.muttrc.local`,
as this is the last file to be sourced.

If you want to have your e-mail signature (not PGP) at the end of every mail
you send, place it in `~/.signature`.

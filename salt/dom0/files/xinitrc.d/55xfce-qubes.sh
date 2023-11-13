#!/bin/sh

# SPDX-FileCopyrightText: 2020 The Qubes OS Project <https://www.qubes-os.org>
# SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: GPL-2.0-only

## Use Qubes provided menu instead of the default one.
case "${XDG_SESSION_DESKTOP-}" in
  KDE|plasma) XDG_MENU_PREFIX="kf5-";;
  *) XDG_MENU_PREFIX="qubes-";;
esac

export XDG_MENU_PREFIX

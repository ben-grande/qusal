#!/bin/sh

## Use Qubes provided menu instead of the default one.
case "$XDG_SESSION_DESKTOP" in
  KDE|plasma) XDG_MENU_PREFIX="kf5-";;
  *) XDG_MENU_PREFIX="qubes-";;
esac
export XDG_MENU_PREFIX

#!/bin/sh

# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

get_os_distro(){
  distro_qube="${1}"
  os_distro="$(qvm-features "${distro_qube}" os-distribution || true)"
}

tagged="$(qvm-ls --no-spinner --raw-list --tags updatevm-sys-cacher | tr "\n" " ")"

wanted=""
for qube in ${tagged}; do
  get_os_distro "${qube}"
  case "${os_distro}" in
    debian|ubuntu|linuxmint|kali|kicksecure|arch)
      continue
      ;;
    "")
      ## AppVMs and DispVMs do not report the features, discover from
      ## their templates.
      klass="$(qvm-prefs "${qube}" klass)"
      case "${klass}" in
        TemplateVM|StandaloneVM)
          ## WARN: creates false positives in case qube never did an update to
          ## report the OS ID, thus reporting both supported qubes that are
          ## not updated yet and unsupported that didn't update yet also.
          wanted="${wanted:+"${wanted} "}${qube}"
          ;;
        AppVM|DispVM)
          case "${klass}" in
            AppVM)
              template="$(qvm-prefs "${qube}" template)"
              ;;
            DispVM)
              app="$(qvm-prefs "${qube}" template)"
              template="$(qvm-prefs "${app}" template)"
              ;;
          esac
          get_os_distro "${template}"
          case "${os_distro}" in
            debian|ubuntu|linuxmint|kali|kicksecure|arch)
              continue
              ;;
            ## Qube is not supported.
            *) wanted="${wanted:+"${wanted} "}${qube}";;
          esac
          ;;
      esac
      ;;
    ## Qube is not supported.
    *) wanted="${wanted:+"${wanted} "}${qube}";;
  esac
done

echo "${wanted}" | tr " " "\n"

#!/bin/sh

## SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

command -v git >/dev/null ||
  { printf '%s\n' "Missing program: git" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
cd "${repo_toplevel}"
unset repo_toplevel
./scripts/requires-program.sh createrepo_c gpg

key_id="$(git config --get user.signingKey)" || true
build_dir="${HOME}/rpmbuild"
qubes_release="r4.2"
repo="current"
dist="fc37"
yum_repo_root="${HOME}/rpmrepo"
yum_repo="${yum_repo_root}/${qubes_release}/${repo}/host/${dist}"

mkdir -p -- "${yum_repo}/rpm"
find "${build_dir}/RPMS/" -type f -name "*.rpm" \
  -exec cp -- {} "${yum_repo}/rpm/" \;

createrepo_args=""
if test -d "${yum_repo}/repodata"; then
  createrepo_args="--update"
fi
# shellcheck disable=SC2086
createrepo_c "${createrepo_args}" --checksum sha512 "${yum_repo}"

if test -n "${key_id}"; then
  rm -f -- "${yum_repo}/repodata/repomd.xml.asc"
  gpg --batch --no-tty --detach-sign --armor --local-user "${key_id}" \
    -- "${yum_repo}/repodata/repomd.xml"
fi

## TODO: rsync to remote host

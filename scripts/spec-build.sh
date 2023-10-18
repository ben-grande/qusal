#!/bin/sh
set -eu

command -v dnf >/dev/null ||
  { printf "Missing program: dnf\n" >&2; exit 1; }
command -v rpmlint >/dev/null ||
  { printf "Missing program: rpmlint\n" >&2; exit 1; }
command -v rpmdev-setuptree >/dev/null ||
  { printf "Missing program: rpmdev-setuptree\n" >&2; exit 1; }
command -v rpmbuild >/dev/null ||
  { printf "Missing program: rpmbuild\n" >&2; exit 1; }
command -v git >/dev/null ||
  { printf "Missing program: git\n" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)" || exit 1

project="${1}"
group="qusal"
spec="rpm_spec/${group}-${project}.spec"
spec_gen="./scripts/spec-gen.sh"

"${spec_gen}" "${project}"
sudo dnf build-dep "${spec}"
rpmlint "${spec}"
rpmdev-setuptree
cp -r "${group}/${project}" ~/rpmbuild/BUILD/"${group}-${project}"
cp -r "${group}/${project}" ~/rpmbuild/SOURCES/"${group}-${project}"
rpmbuild -ba "${spec}"

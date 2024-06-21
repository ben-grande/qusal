# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

## Reproducibility.
%define source_date_epoch_from_changelog 1
%define use_source_date_epoch_as_buildtime 1
%define clamp_mtime_to_source_date_epoch 1
# Changelog is trimmed according to current date, not last date from changelog.
%define _changelog_trimtime 0
%define _changelog_trimage 0
%global _buildhost %{name}
# Python bytecode interferes when updates occur and restart is not done.
%undefine __brp_python_bytecompile

Name:           qusal-sys-cacher
Version:        0.0.1
Release:        1%{?dist}
Summary:        Caching proxy server for software repositories in Qubes OS

Group:          qusal
Packager:       Ben Grande
Vendor:         Ben Grande
License:        AGPL-3.0-or-later AND GPL-2.0-only
URL:            https://github.com/ben-grande/qusal
BugURL:         https://github.com/ben-grande/qusal/issues
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       qubes-mgmt-salt
Requires:       qubes-mgmt-salt-dom0
Requires:       qusal-browser
Requires:       qusal-dotfiles
Requires:       qusal-utils


%description
The caching proxy is "sys-cacher" based on apt-cacher-ng, it stores downloaded
packages, so that you need only download a package once and fetch locally the
next time you want to upgrade your system packages.

When you install this package, qubes will be tagged with "updatevm-sys-cacher"
and they will be altered to use the proxy by default. When there is "https://"
in your repository definitions, the entries will be changed in the templates
from to "http://HTTPS///". This is so that the request to the proxy is plain
text, and the proxy will then make the request via https.

This change will be done automatically for every template that exists and is
not Whonix based. No changes are made to Whonix templates, and updates to
those templates will not be cached.

The caching proxy supports:

- Debian and derivatives (but not Whonix)
- Fedora and derivatives
- Arch Linux and derivatives

%prep
%setup -q

%build

%install
rm -rf %{buildroot}
install -m 755 -d \
  %{buildroot}/srv/salt/qusal \
  %{buildroot}%{_docdir}/%{name} \
  %{buildroot}%{_defaultlicensedir}/%{name}
install -m 644 %{name}/LICENSES/* %{buildroot}%{_defaultlicensedir}/%{name}/
install -m 644 %{name}/README.md %{buildroot}%{_docdir}/%{name}/
rm -rv %{name}/LICENSES %{name}/README.md
cp -rv %{name} %{buildroot}/srv/salt/qusal/%{name}

%check

%dnl %pre

%post
if test "$1" = "1"; then
  ## Install
  qubesctl state.apply sys-cacher.create
  qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install
  qubesctl --skip-dom0 --targets=tpl-sys-cacher state.apply sys-cacher.install
  qubesctl --skip-dom0 --targets=sys-cacher state.apply sys-cacher.configure
  qubesctl --skip-dom0 --targets=sys-cacher-browser state.apply sys-cacher.configure-browser
  qubesctl state.apply sys-cacher.appmenus,sys-cacher.tag
  qubesctl --skip-dom0 --targets="$(qvm-ls --no-spinner --raw-list --tags updatevm-sys-cacher | tr "
  " ",")" state.apply sys-cacher.install-client
elif test "$1" = "2"; then
  ## Upgrade
  true
fi

%preun
if test "$1" = "0"; then
  ## Uninstall
  true
elif test "$1" = "1"; then
  ## Upgrade
  true
fi

%postun
if test "$1" = "0"; then
  ## Uninstall
  true
elif test "$1" = "1"; then
  ## Upgrade
  true
fi

%files
%defattr(-,root,root,-)
%license %{_defaultlicensedir}/%{name}/*
%doc %{_docdir}/%{name}/README.md
%dir /srv/salt/qusal/%{name}
/srv/salt/qusal/%{name}/*
%dnl TODO: missing '%ghost', files generated during %post, such as Qrexec policies.

%changelog
* Mon Jun 17 2024 Ben Grande <ben.grande.b@gmail.com> - 59e8fc3
- fix: GUI Global Config precedes packaged policies

* Thu Jun 13 2024 Ben Grande <ben.grande.b@gmail.com> - 75d992b
- fix: use Admin API for fast queries

* Thu Jun 13 2024 Ben Grande <ben.grande.b@gmail.com> - 13c5793
- fix: uninstall cacher client with tag in pillar

* Mon Jun 10 2024 Ben Grande <ben.grande.b@gmail.com> - c456af2
- fix: remove duplicated Fedora mirrors

* Mon Jun 10 2024 Ben Grande <ben.grande.b@gmail.com> - 8ae815d
- fix: run repo rewriter after upstream proxy update

* Mon Jun 10 2024 Ben Grande <ben.grande.b@gmail.com> - b4de619
- fix: update Debian and Fedora mirrors

* Mon Jun 10 2024 Ben Grande <ben.grande.b@gmail.com> - 2b181f8
- fix: merge Qubes OS repositories

* Sun Jun 09 2024 Ben Grande <ben.grande.b@gmail.com> - d2771d5
- fix: guarantee states order dependent on browser

* Fri Jun 07 2024 Ben Grande <ben.grande.b@gmail.com> - bb38440
- feat: revive caching of Fedora qubes

* Wed May 29 2024 Ben Grande <ben.grande.b@gmail.com> - bb4dcbb
- fix: cacher: restrict install to supported clients

* Wed May 29 2024 Ben Grande <ben.grande.b@gmail.com> - 9cb7d72
- fix: cacher: use systemd service drop-in directory

* Wed May 29 2024 Ben Grande <ben.grande.b@gmail.com> - a2e1972
- fix: cache Mozilla and Element repository

* Thu May 16 2024 Ben Grande <ben.grande.b@gmail.com> - b2c9479
- fix: enforce https on repository installation

* Tue Apr 30 2024 Ben Grande <ben.grande.b@gmail.com> - e84959b
- fix: update fedora mirror list with upstream

* Tue Apr 30 2024 Ben Grande <ben.grande.b@gmail.com> - 760fdd9
- doc: cacher documentation duplicates sections

* Mon Apr 29 2024 Ben Grande <ben.grande.b@gmail.com> - bfd7b22
- fix: incorrect path to repo rewriter service

* Fri Apr 26 2024 Ben Grande <ben.grande.b@gmail.com> - 234afc3
- doc: update cacher table of contents

* Fri Apr 26 2024 Ben Grande <ben.grande.b@gmail.com> - 1ede2e1
- fix: allow update check to work on cacher clients

* Thu Apr 25 2024 Ben Grande <ben.grande.b@gmail.com> - a6f7d23
- doc: wrong cacher header position

* Thu Apr 25 2024 Ben Grande <ben.grande.b@gmail.com> - 648bdad
- fix: remove updatevm tag after DomU uninstallation

* Sat Apr 13 2024 Ben Grande <ben.grande.b@gmail.com> - 63e93be
- fix: GUI policy precedes sys-cacher policy

* Mon Mar 25 2024 Ben Grande <ben.grande.b@gmail.com> - 084d08f
- doc: uninstall cacher client based on tag

* Thu Mar 21 2024 Ben Grande <ben.grande.b@gmail.com> - 4ac0ec9
- fix: cacher jinja fails to split words

* Thu Mar 21 2024 Ben Grande <ben.grande.b@gmail.com> - 7faf944
- feat: apply URI changes in qube

* Thu Mar 21 2024 Ben Grande <ben.grande.b@gmail.com> - 9e96d80
- fix: add missing archlinux mirror

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Thu Feb 22 2024 Ben Grande <ben.grande.b@gmail.com> - 0cd3e66
- fix: remove hardcoded fedora versions from cacher

* Thu Feb 22 2024 Ben Grande <ben.grande.b@gmail.com> - 908a077
- fix: allow apt-cacher-ng cronjob to run

* Thu Feb 22 2024 Ben Grande <ben.grande.b@gmail.com> - 23dbc72
- fix: update apt-cacher-ng mirror list

* Mon Feb 19 2024 Ben Grande <ben.grande.b@gmail.com> - 89bd760
- feat: add OpenTofu

* Wed Jan 31 2024 Ben Grande <ben.grande.b@gmail.com> - b5d7371
- fix: thunar requires xfce helpers to find terminal

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Thu Jan 18 2024 Ben Grande <ben.grande.b@gmail.com> - 0887c24
- fix: remove unicode from used files

* Fri Jan 12 2024 Ben Grande <ben.grande.b@gmail.com> - 8d7c0a2
- fix: sys-cacher policy with the new tag name

* Fri Jan 12 2024 Ben Grande <ben.grande.b@gmail.com> - 233ac76
- fix: sys-cacher tag compliance with default tags

* Fri Jan 12 2024 Ben Grande <ben.grande.b@gmail.com> - a97e3c0
- feat: kicksecure minimal template

* Wed Jan 10 2024 Ben Grande <ben.grande.b@gmail.com> - 2b6daac
- fix: shellcheck

* Wed Dec 20 2023 Ben Grande <ben.grande.b@gmail.com> - 38d98ec
- fix: nft shebang and table names

* Wed Dec 20 2023 Ben Grande <ben.grande.b@gmail.com> - d3ae662
- fix: cacher client installation indentation

* Wed Dec 20 2023 Ben Grande <ben.grande.b@gmail.com> - a78b90e
- fix: better output for cacher tag assignment

* Tue Dec 19 2023 Ben Grande <ben.grande.b@gmail.com> - 71d22c5
- refactor: reorder states to avoid race condition

* Tue Dec 19 2023 Ben Grande <ben.grande.b@gmail.com> - b4d142b
- refactor: move appended states to drop-in rc.local

* Tue Dec 19 2023 Ben Grande <ben.grande.b@gmail.com> - e670d02
- fix: skip client setup on cacher initialization

* Tue Nov 21 2023 Ben Grande <ben.grande.b@gmail.com> - ec2dab3
- fix: stop modifying distribution package files

* Tue Nov 14 2023 Ben Grande <ben.grande.b@gmail.com> - 41c5418
- fix: cacher shuting down on long running updates

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 963e72c
- chore: Fix unman copyright contact

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit

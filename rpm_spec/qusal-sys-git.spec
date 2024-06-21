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

Name:           qusal-sys-git
Version:        0.0.1
Release:        1%{?dist}
Summary:        Git operations through Qrexec in Qubes OS

Group:          qusal
Packager:       Ben Grande
Vendor:         Ben Grande
License:        AGPL-3.0-or-later
URL:            https://github.com/ben-grande/qusal
BugURL:         https://github.com/ben-grande/qusal/issues
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       qubes-mgmt-salt
Requires:       qubes-mgmt-salt-dom0
Requires:       qusal-dev
Requires:       qusal-dotfiles
Requires:       qusal-sys-pgp
Requires:       qusal-utils


%description
Setup a Git server called "sys-git", an offline Git Server that can be
accessed from client qubes via Qrexec. Access control via Qrexec policy can
restrict access to certain repositories, set of git actions for Fetch, Push
and Init. This is an implementation of split-git.

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
  qubesctl state.apply sys-git.create
  qubesctl --skip-dom0 --targets=tpl-sys-git state.apply sys-git.install
  qubesctl --skip-dom0 --targets=sys-git state.apply sys-git.configure
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
* Wed Jun 19 2024 Ben Grande <ben.grande.b@gmail.com> - bf0a4bc
- fix: terminate option parsing for qvm commands

* Tue Jun 04 2024 Ben Grande <ben.grande.b@gmail.com> - 8d9ad74
- fix: correct man-db typo

* Tue May 28 2024 Ben Grande <ben.grande.b@gmail.com> - 44ea4c5
- feat: add manual page reader

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Mon Mar 11 2024 Ben Grande <ben.grande.b@gmail.com> - beb5c04
- fix: start qube before running qrexec-client

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Thu Jan 18 2024 Ben Grande <ben.grande.b@gmail.com> - 04a016e
- doc: attacker can display a large byte set

* Thu Jan 18 2024 Ben Grande <ben.grande.b@gmail.com> - f8ea066
- doc: how to update the repository

* Thu Jan 18 2024 Ben Grande <ben.grande.b@gmail.com> - 23bcceb
- fix: dom0 as sys-git client

* Thu Dec 28 2023 Ben Grande <ben.grande.b@gmail.com> - b52e4b1
- fix: strict split-gpg2 service

* Thu Dec 21 2023 Ben Grande <ben.grande.b@gmail.com> - f21f676
- fix: dom0 qrexec call target qube

* Thu Dec 21 2023 Ben Grande <ben.grande.b@gmail.com> - a820751
- refactor: git Qrexec helper with drop-in commands

* Tue Nov 21 2023 Ben Grande <ben.grande.b@gmail.com> - 10b3bcd
- fix: unstrusted input marking and sanitization

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit

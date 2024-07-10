# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         dom0
%define license_csv     AGPL-3.0-or-later,GPL-2.0-only,GPL-3.0-or-later,MIT
## Reproducibility.
%define source_date_epoch_from_changelog 1
%define use_source_date_epoch_as_buildtime 1
%define clamp_mtime_to_source_date_epoch 1
## Changelog is trimmed according to current date, not last date from changelog.
%define _changelog_trimtime 0
%define _changelog_trimage 0
%global _buildhost %{name}
## Python bytecode interferes when updates occur and restart is not done.
%undefine __brp_python_bytecompile

Name:           qusal-dom0
Version:        0.0.1
Release:        1%{?dist}
Summary:        Dom0 environment in Qubes OS
Group:          qusal
Packager:       %{?_packager}%{!?_packager:Ben Grande <ben.grande.b@gmail.com>}
Vendor:         Ben Grande
License:        AGPL-3.0-or-later AND GPL-2.0-only AND GPL-3.0-or-later AND MIT
URL:            https://github.com/ben-grande/qusal
BugURL:         https://github.com/ben-grande/qusal/issues
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       qubes-mgmt-salt
Requires:       qubes-mgmt-salt-dom0
Requires:       qusal-dotfiles
Requires:       qusal-sys-git
Requires:       qusal-utils


%description
Configure Dom0 window manager, install packages, backup scripts and profile
etc.

%prep
%setup -q

%build

%check

%pre

%install
rm -rf %{buildroot}
install -m 755 -d \
  %{buildroot}/srv/salt/qusal \
  %{buildroot}%{_docdir}/%{name} \
  %{buildroot}%{_defaultlicensedir}/%{name}

for license in $(echo "%{license_csv}" | tr "," " "); do
  license_dir="LICENSES"
  if test -d "salt/%{project}/LICENSES"; then
    license_dir="salt/%{project}/LICENSES"
  fi
  install -m 644 "${license_dir}/${license}.txt" %{buildroot}%{_defaultlicensedir}/%{name}/
done

install -m 644 salt/%{project}/README.md %{buildroot}%{_docdir}/%{name}/
rm -rf \
  salt/%{project}/LICENSES \
  salt/%{project}/README.md \
  salt/%{project}/.*
cp -rv salt/%{project} %{buildroot}/srv/salt/qusal/%{name}

%post
if test "$1" = "1"; then
  ## Install
  qubesctl state.apply dom0
  qubesctl --skip-dom0 --templates --standalones state.apply update.qubes-vm
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
* Wed Jul 10 2024 Ben Grande <ben.grande.b@gmail.com> - 224312e
- feat: enable all optional shellcheck validations

* Tue Jul 09 2024 Ben Grande <ben.grande.b@gmail.com> - 011a71a
- style: limit line length per file extension

* Mon Jul 08 2024 Ben Grande <ben.grande.b@gmail.com> - 523bca2
- fix: conform files to editorconfig specification

* Thu Jul 04 2024 Ben Grande <ben.grande.b@gmail.com> - 383c840
- doc: lint markdown files

* Fri Jun 28 2024 Ben Grande <ben.grande.b@gmail.com> - f903c0e
- feat: get GUI user with salt modules

* Wed Jun 26 2024 Ben Grande <ben.grande.b@gmail.com> - c2fc4b5
- feat: show origin template features of any class

* Mon Jun 24 2024 Ben Grande <ben.grande.b@gmail.com> - e9801c8
- feat: helper to show mgmt property information

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Tue Jun 18 2024 Ben Grande <ben.grande.b@gmail.com> - 8d5c1c9
- chore: typo in date command

* Sun Jun 09 2024 Ben Grande <ben.grande.b@gmail.com> - fcf7fe9
- fix: guarantee a fully updated system on bootstrap

* Sat Jun 08 2024 Ben Grande <ben.grande.b@gmail.com> - 1003d62
- fix: KDE with outdated require id

* Fri Jun 07 2024 Ben Grande <ben.grande.b@gmail.com> - efc3984
- feat: allow terminal and file manager choice

* Tue Jun 04 2024 Ben Grande <ben.grande.b@gmail.com> - 34d5d36
- feat: add state for desktop i3 and AwesomeWM

* Fri May 24 2024 Ben Grande <ben.grande.b@gmail.com> - efcf8c7
- fix: unify screenshot tool existence logic

* Fri May 24 2024 Ben Grande <ben.grande.b@gmail.com> - 444672e
- fix: prefer maim for screenshot

* Tue May 14 2024 Ben Grande <ben.grande.b@gmail.com> - d148599
- doc: nested list indentation

* Wed May 01 2024 Ben Grande <ben.grande.b@gmail.com> - 18204da
- fix: import jinja template to dom0 kde state

* Tue Apr 30 2024 Ben Grande <ben.grande.b@gmail.com> - 5722a25
- fix: discover non-root username at runtime

* Fri Mar 22 2024 Ben Grande <ben.grande.b@gmail.com> - 81bf77c
- fix: missing load import

* Wed Mar 20 2024 Ben Grande <ben.grande.b@gmail.com> - 004cb73
- fix: restrict supported screenshot tools

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - fc2af9b
- fix: remove colors from output of backup file

* Fri Mar 15 2024 Ben Grande <ben.grande.b@gmail.com> - 425748a
- fix: install screenshot dependencies

* Wed Mar 13 2024 Ben Grande <ben.grande.b@gmail.com> - 134a26a
- feat: add screenshot helper

* Mon Feb 26 2024 Ben Grande <ben.grande.b@gmail.com> - e7a7649
- fix: remove dom0 port forwarding default install

* Sat Feb 24 2024 Ben Grande <ben.grande.b@gmail.com> - f3953eb
- fix: convert backup profile to example type

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 766a430
- fix: typo in file name

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - f513f64
- feat: better dom0 terminal usability

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - b01f2d2
- chore: move port forward to dom0 formula

* Thu Jan 18 2024 Ben Grande <ben.grande.b@gmail.com> - 0887c24
- fix: remove unicode from used files

* Thu Jan 18 2024 Ben Grande <ben.grande.b@gmail.com> - 23bcceb
- fix: dom0 as sys-git client

* Tue Jan 02 2024 Ben Grande <ben.grande.b@gmail.com> - b86486a
- feat: qubes-vm-update global settings

* Sun Dec 31 2023 Ben Grande <ben.grande.b@gmail.com> - ec9142b
- fix: pci regain with invalid syntax

* Wed Dec 27 2023 Ben Grande <ben.grande.b@gmail.com> - 250c877
- fix: regain pci script not managed

* Wed Dec 20 2023 Ben Grande <ben.grande.b@gmail.com> - c2f2584
- feat: provide development environment for dom0

* Tue Dec 19 2023 Ben Grande <ben.grande.b@gmail.com> - b4b7f27
- fix: qubes-update superseded by qubes-vm-update

* Tue Dec 19 2023 Ben Grande <ben.grande.b@gmail.com> - bcc8165
- fix: salt syntax with missing characters

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 963e72c
- chore: Fix unman copyright contact

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit

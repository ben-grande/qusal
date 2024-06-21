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

Name:           qusal-sys-pgp
Version:        0.0.1
Release:        1%{?dist}
Summary:        PGP operations through Qrexec in Qubes OS

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
Requires:       qusal-fedora-minimal
Requires:       qusal-utils


%description
Creates a PGP key holder named "sys-pgp", it will be the default target for
split-gpg and split-gpg2 calls for all qubes. Keys are stored in "sys-pgp",
and access to them is made from the client through Qrexec.

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
  qubesctl state.apply sys-pgp.create
  qubesctl --skip-dom0 --targets=tpl-sys-pgp state.apply sys-pgp.install
  qubesctl --skip-dom0 --targets=sys-pgp state.apply sys-pgp.configure
  qubesctl state.apply sys-pgp.prefs
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
* Thu Jun 20 2024 Ben Grande <ben.grande.b@gmail.com> - 7ab3b93
- fix: correct upstream repository owner

* Mon Jun 17 2024 Ben Grande <ben.grande.b@gmail.com> - 1a72665
- feat: add split-gpg2 configuration

* Fri Jun 14 2024 Ben Grande <ben.grande.b@gmail.com> - e1a15d8
- fix: pgp template is fedora based without salt fix

* Tue May 28 2024 Ben Grande <ben.grande.b@gmail.com> - bc8213b
- fix: split-gpg2 fedora clashes with debian agent

* Tue May 28 2024 Ben Grande <ben.grande.b@gmail.com> - 44ea4c5
- feat: add manual page reader

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Wed Jan 31 2024 Ben Grande <ben.grande.b@gmail.com> - 8ff1998
- feat: install available sequoia-pgp tools

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Thu Dec 28 2023 Ben Grande <ben.grande.b@gmail.com> - b52e4b1
- fix: strict split-gpg2 service

* Wed Dec 27 2023 Ben Grande <ben.grande.b@gmail.com> - a617c3d
- fix: modify package names to match Qubes 4.2

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
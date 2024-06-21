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

Name:           qusal-mirage-builder
Version:        0.0.1
Release:        1%{?dist}
Summary:        Mirage Builder environment in Qubes OS

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
Requires:       qusal-docker
Requires:       qusal-dotfiles
Requires:       qusal-sys-git
Requires:       qusal-sys-pgp
Requires:       qusal-sys-ssh-agent
Requires:       qusal-utils


%description
Setup a builder qube for Mirage Unikernel named "mirage-builder". The tool
necessary to build Mirage with docker or directly with Opam will also be
installed.

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
  qubesctl state.apply mirage-builder.create
  qubesctl --skip-dom0 --targets=tpl-mirage-builder state.apply mirage-builder.install
  qubesctl --skip-dom0 --targets=mirage-builder state.apply mirage-builder.configure
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
* Tue May 14 2024 Ben Grande <ben.grande.b@gmail.com> - d148599
- doc: nested list indentation

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Fri Jan 05 2024 Ben Grande <ben.grande.b@gmail.com> - 417843b
- feat: remove extraneous passwordless root

* Wed Jan 03 2024 Ben Grande <ben.grande.b@gmail.com> - 6bb426a
- refactor: import armored gpg keys instead of db

* Thu Dec 28 2023 Ben Grande <ben.grande.b@gmail.com> - b52e4b1
- fix: strict split-gpg2 service

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
